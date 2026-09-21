
module "eks_vpc" {
  source = "./modules/vpc"
}

module "bastion_host" {
  source = "./modules/bastion"
  subnet_id = module.eks_vpc.public_subnets_id[0]
  security_group_id = module.eks_vpc.bastion_host_security_group_id

  depends_on = [ module.eks_vpc ]
}

module "first_cluster" {
  source = "./modules/eks"
  subnet_ids = module.eks_vpc.private_subnets_id
  eks_admin_arn = module.bastion_host.eks_admin_arn
  cluster_security_group_id = module.eks_vpc.cluster_security_group_id

depends_on = [ module.eks_vpc, module.bastion_host ]
}