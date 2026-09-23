output "vpc_id" {
  value = module.eks_vpc.vpc_id
  description = "VPC Id where the worker nodes are deployed"
}

output "bastion_host_ip" {
  value = module.bastion_host.bastion_host_ip
  description = "Public IP Address of the Bastion Host"
}

output "cluster_ca_data" {
  value = module.first_cluster.cluster_ca_data
  description = "base64 encoded CA data to be used in certificate-authority-data section of kubeconfig file"
}

output "cluster_endpoint" {
  value = module.first_cluster.cluster_endpoint
  description = "API Server Endpoint URL of the Cluster"
}