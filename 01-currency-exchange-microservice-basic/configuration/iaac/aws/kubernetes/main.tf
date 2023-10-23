# aws --version
# aws eks --region us-east-1 update-kubeconfig --name in28minutes-cluster
# Uses default VPC and Subnet. Create Your Own VPC and Private Subnets for Prod Usage.
# terraform-backend-state-in28minutes-123
# AKIA4AHVNOD7OOO6T4KI


terraform {
  backend "s3" {
    bucket = "mybucket" # Will be overridden from build
    key    = "path/to/my/key" # Will be overridden from build
    region = "ap-south-1"
  }
}

resource "aws_default_vpc" "default" {

}





module "biju" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "biju1-cluster"
  #cluster_version = "~>1.14"
  subnet_ids       = ["subnet-0bfd3d382d079c9d8", "subnet-006dba2ac9fa506d3"] #CHANGE
  #subnets = data.aws_subnet_ids.subnets.ids
  #vpc_id          = aws_default_vpc.default.id

  vpc_id         = "vpc-02b83871319ed6a24"
 # cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    instance_types         = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 3
      max_size     = 5
      desired_size = 3

      instance_types = ["t2.micro"]
}
}
}

data "aws_eks_cluster" "cluster" {
  name = module.biju.cluster_name
  depends_on = [module.biju.cluster_name]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.biju.cluster_name
  depends_on = [module.biju.cluster_name]
}



provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data))
  token                  = data.aws_eks_cluster_auth.cluster.token
  #version                = "~> 19.0"
}


# We will use ServiceAccount to connect to K8S Cluster in CI/CD mode
# ServiceAccount needs permissions to create deployments 
# and services in default namespace
resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "fabric8-rbac"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "default"
  }
}

# Needed to set the default region
provider "aws" {
  region  = "ap-south-1"
}
