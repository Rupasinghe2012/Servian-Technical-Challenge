#!/bin/sh

set -e

echo "-- Load the system variables to connect to AWS --"
$(cat credentials.txt)
rm credentials.txt

echo "-- Connect to K8S with administration permissions --"
aws eks update-kubeconfig --region ${region} --name ${cluster_name}
chmod 600 ~/.kube/config

echo "-- Show info of the cluster --"
kubectl cluster-info

echo "-- Configure the roles and allow the nodes to join --"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${eks_node_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:masters
        - system:nodes
    - rolearn: ${eks_fargate_role_arn}
      username: system:node:{{SessionName}}
      groups:
        - system:bootstrappers
        - system:nodes
        - system:node-proxier
  mapUsers: |
%{ for user_arn in eks_arn_user_list_with_masters_user ~}
    - groups:
        - system:masters
      userarn: ${user_arn}
      username: user-admin::{{SessionName}}
%{ endfor ~}
EOF



echo "-- Configure the POD's to have internet access --"
kubectl -n kube-system set env daemonset aws-node AWS_VPC_K8S_CNI_EXTERNALSNAT=true

echo "-- Reconfigured CoreDNS for Fargate --"
# kubectl patch deployment coredns -n kube-system --type json -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]' || true
kubectl patch deployment coredns -n kube-system --type json -p='[{"op": "add", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type", "value":"fargate"}]' || true

echo "-- Restart deploy CoreDNS --"
kubectl rollout restart -n kube-system deploy coredns

echo "-- Configure aws load balancer controller --"
helm repo add eks https://aws.github.io/eks-charts
# Disable exit on non 0
set +e
helm install aws-load-balancer-controller \
  eks/aws-load-balancer-controller \
  --set clusterName=${cluster_name} \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.create=true \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="${eks_lb_controller_role_arn}" \
  --set region=${region} \
  --set vpcId=${vpc_id} \
  -n kube-system -f alb_ing_helm_values.yaml
# Enable exit on non 0
set -e

# Incase if change needs to be applied to exisitng ALB ingress controller
helm upgrade aws-load-balancer-controller \
  eks/aws-load-balancer-controller \
  --set clusterName=${cluster_name} \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.create=true \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="${eks_lb_controller_role_arn}" \
  --set region=${region} \
  --set vpcId=${vpc_id} \
  -n kube-system -f alb_ing_helm_values.yaml

echo "-- Restart deploy AWS Load Balancer Controller --"
kubectl rollout restart -n kube-system deploy aws-load-balancer-controller

echo "-- Configure external dns --"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: ${eks_external_dns_role_arn}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: external-dns
  namespace: kube-system
rules:
- apiGroups: [""]
  resources: ["services","endpoints","pods"]
  verbs: ["get","watch","list"]
- apiGroups: ["extensions","networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get","watch","list"]
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["list","watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: external-dns-viewer
  namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: external-dns
subjects:
- kind: ServiceAccount
  name: external-dns
  namespace: kube-system
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
  namespace: kube-system
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: external-dns
  template:
    metadata:
      labels:
        app: external-dns
    spec:
      serviceAccountName: external-dns
      containers:
      - name: external-dns
        image: k8s.gcr.io/external-dns/external-dns:v0.7.3
        args:
        - --source=service
        - --source=ingress
        - --domain-filter=${domain_name}
        - --provider=aws
        - --policy=upsert-only # would prevent ExternalDNS from deleting any records, omit to enable full synchronization
        - --aws-zone-type=public # only look at public hosted zones (valid values are public, private or no value for both)
        - --registry=txt
        - --txt-owner-id=axa-gulf
      securityContext:
        fsGroup: 65534 # For ExternalDNS to be able to read Kubernetes and AWS token files
EOF


echo "-- Restart deploy external dns --"
kubectl rollout restart -n kube-system deploy external-dns


echo "-- ****** DEPLOY Metrics Server for use of Horizontal Pod Autoscaler ****** --"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo ${app_backend_db_password}
echo ${app_backend_db_user}
echo "-- ****** DEPLOY SERVIAN TECH CHALLENGE APP ****** --"
helm upgrade --install servian \
  /home/ec2-user/charts/serivan-app \
  --set ingress.cert_arn=${eks_alb_ing_ssl_cert_arn} \
  --set AppSecrets.dbuser=${app_backend_db_user} \
  --set AppSecrets.dbpassword=${app_backend_db_password} \
  --set ConfigMapValues.DbHost=${app_backend_db_host} \
  -n default

echo "-- ****** CONFIGURE DB TABLES OF SERVIAN APP IN INITIAL RUN ****** --"
sleep 180

kubectl exec -it --namespace=default $(kubectl get pods -o name -A | grep -m1 servian) -- sh -c "./TechChallengeApp updatedb -s"

echo "-- ****** PRINT load balancer HOSTNAME ****** --"
sleep 2
LB_HOST_NAME=`kubectl get ing servian-serivan-app -o='custom-columns=Address:.status.loadBalancer.ingress[0].hostname' --no-headers`
echo "Servian Tech Challenge App can be accessed via: https://$LB_HOST_NAME"
