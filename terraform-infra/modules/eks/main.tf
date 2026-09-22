data "aws_iam_role" "cluster_role" {
  name = "AmazonEKSClusterRole"
}

data "aws_iam_role" "node_role" {
  name = "AmazonEKSNodeRole"
}


resource "aws_eks_cluster" "first_eks_cluster" {
  name = "xxx-xxx-xxx"

  access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  role_arn = data.aws_iam_role.cluster_role.arn
  version  = "1.34"

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access = false
    security_group_ids = [var.cluster_security_group_id]
  }
}

resource "aws_eks_node_group" "first_eks_ng" {
  cluster_name    = aws_eks_cluster.first_eks_cluster.name
  node_group_name = "first-eks-ng"

  version         = aws_eks_cluster.first_eks_cluster.version

  node_role_arn   = data.aws_iam_role.node_role.arn
  subnet_ids      = var.subnet_ids

  instance_types = ["c7i-flex.large", "t3.small"]

  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 1
  }

  remote_access {
    ec2_ssh_key = "bastion_host_key.pub"
  }

  timeouts {
    create = "20m"
  }
}

resource "aws_eks_access_entry" "first_eks_access_entry" {
  cluster_name      = aws_eks_cluster.first_eks_cluster.name
  principal_arn     = var.eks_admin_arn
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "first_eks_access_policy_association" {
  cluster_name  = aws_eks_cluster.first_eks_cluster.name

  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.eks_admin_arn

  access_scope {
    type       = "cluster"
  }
}

resource "aws_iam_openid_connect_provider" "first_eks_cluster_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  url             = aws_eks_cluster.first_eks_cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "ebs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.first_eks_cluster_oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.first_eks_cluster_oidc_provider.arn]
      type        = "Federated"
    }
  }
}

####################################################
### IAM Role for EBS CSI Driver Service Accounts ###
####################################################

resource "aws_iam_role" "ebs_csi_driver_role" {
  assume_role_policy = data.aws_iam_policy_document.ebs_assume_role_policy.json
  name               = "AmazonEBSCSIDriverSARole"
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
  role       = aws_iam_role.ebs_csi_driver_role.name
}

####################################################
########### EKS Addon - EBS CSI Driver #############
####################################################

resource "aws_eks_addon" "ebs_csi_driver_addon" {
  cluster_name = aws_eks_cluster.first_eks_cluster.name
  addon_name = "aws-ebs-csi-driver"
  addon_version = "v1.66.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.ebs_csi_driver_role.arn
}