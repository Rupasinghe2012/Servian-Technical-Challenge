# 3. Identify Prerequisites and Design decisions 

Date: 2022-07-06

## Status

Accepted

## Context

Identify the prequsites and Design decisions that covers Network, Security, Resiliency.

## Decision

* Considered following requirements of the challange, and came up with design decisions.
  
  * Security 

    Reqirement| Decision |
    ---------|----------|
    Network segmentation | * Avoid use of defaul vpc<br /> *Take steps to create new VPC covering all AZs.c<br /> *Create separate pivate Subnet group for Database.
    Secret storage | * Store credentials, keys in AWS Secrets Manager. 
    Config Management | * Store Application Config values non sensetive,  in AWS SSM Parameter Store.
    Platform security features | * Avoid direct expose of port 80/ HTTP <br/> * Only expose port 443/HTTPS and Configure secure SSL certificate. <br/> * Expose EKS Control plane only via a Bastion Host.

* Resiliency

    Reqirement | Decision
    ---------|----------
    Auto scaling and highly available frontend | * Referrs to high availablity of application.<br /> *Consider use of containerized approach over the EC2/VM based approach (considering easy and efficient **Auto Scalability** of containers) <br /> *Cosider use of ECS or EKS for the container ochestration. [E.g: i) [ECS Auto Scaling](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-auto-scaling.html), ii) [EKS Cluster node and pod autoscaling](https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html) iii) [EKS Fargate Autoscaling](https://aws.amazon.com/blogs/containers/autoscaling-eks-on-fargate-with-custom-metrics/)  ] </br> * Consider use if ALB for Load Balancing traffic to frontend application to gain **High Availablity** for the frontend. [E.g: i) [ECS Service load balancing](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-load-balancing.html), ii) [EKS Load balancer with Nginx Ingress Controller](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/)]
    Highly available Database | * Reffers to availability of backend database, which might affect functionality of application. <br /> * Make use of [High availability (Multi-AZ) for Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html) with automatic failover.


## Consequences

None