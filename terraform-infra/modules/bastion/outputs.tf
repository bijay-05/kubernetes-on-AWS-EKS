output "eks_admin_arn" {
  value = aws_iam_role.bastion_eks_role.arn
  description = "ARN of the IAM Role with Admin Access To EKS Cluster"
}

output "bastion_host_ip" {
  value = aws_instance.bastion_host.public_ip
  description = "Public IP Address of the Bastion Host"
}