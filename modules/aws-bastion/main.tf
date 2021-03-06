# bastion user data
locals {
  bastion_server_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
cat <<EOF > /etc/profile.d/bastion.sh
export PATH=$PATH:/usr/local/bin
EOF

# Install dependencies
yum update -y
yum install -y git vim telnet jq cifs-utils unzip telnet nc python3-pip python3 python3-setuptools
yum install -y amazon-efs-utils

# Install HELM
curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2

# Install KUBECTL
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# Install aws-iam-authenticator
curl -o aws-iam-authenticator https://s3.us-west-2.amazonaws.com/amazon-eks/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# Install eksctl
# curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
# sudo mv /tmp/eksctl /usr/local/bin
# Change port
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
systemctl restart sshd

USERDATA
}

# launch configuration for the bastion server
resource "aws_launch_configuration" "bastion_server" {
  associate_public_ip_address = var.bastion_public_ip_enabled
  iam_instance_profile        = var.iam_instance_profile
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  name_prefix                 = lower("${var.app_name}-bastion-lc")
  security_groups             = var.instance_security_groups
  user_data_base64            = base64encode(local.bastion_server_userdata)
  key_name                    = var.instance_keypair

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size           = var.block_volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.block_delete_on_termination
  }

}

resource "aws_autoscaling_group" "bastion_autoscaling_group" {
  desired_capacity     = var.asg_desired_capacity
  launch_configuration = aws_launch_configuration.bastion_server.id
  max_size             = var.asg_max_size
  min_size             = var.asg_min_size
  name                 = lower("${var.app_name}-bastion-autoscaling-group")
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "${var.app_name}-bastion"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

}
