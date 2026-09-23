output "cluster_ca_data" {
  value = aws_eks_cluster.first_eks_cluster.certificate_authority.data
  description = "base64 encoded CA data to be used in certificate-authority-data section of kubeconfig file"
}

output "cluster_endpoint" {
  value = aws_eks_cluster.first_eks_cluster.endpoint
  description = "API Server Endpoint URL of the Cluster"
}