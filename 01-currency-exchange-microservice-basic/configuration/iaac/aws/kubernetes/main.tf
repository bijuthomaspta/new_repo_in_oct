terraform {
  backend "s3" {
    bucket = "mybucket" # Will be overridden from build
    key    = "path/to/my/key" # Will be overridden from build
    region = "ap-south-1"
  }
}

#resource "aws_default_vpc" "default" {

#}

# data "aws_subnet_ids" "subnets" {
#   vpc_id = aws_default_vpc.default.id
# }

data "aws_eks_cluster" "cluster" { 
  name = module.my-cluster.cluster_name
}

data "aws_eks_cluster_auth" "cluster" { 
  name = module.my-cluster.cluster_name
}


# data "aws_region" "current" {}


#provider "kubernetes" {
 # host                   = data.aws_eks_cluster.cluster.endpoint
 # cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
 # token                  = data.aws_eks_cluster_auth.cluster.token
#}
provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}



module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster_in_aws_eks"
#   cluster_version = "1.14"
  subnet_ids = ["subnet-0bfd3d382d079c9d8", "subnet-006dba2ac9fa506d3"] 
  #vpc_id          = aws_default_vpc.default.id

  vpc_id         = "vpc-02b83871319ed6a24"

  eks_managed_node_groups = {
    one = {
      instance_type = "t2.micro"
      max_capacity  = 3
      desired_capacity = 3
      min_capacity  = 1
    }
  }

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
output "auth" {
  value = data.aws_eks_cluster.cluster.certificate_authority.0.data
  sensitive = true

}

output "token" {
  value =  data.aws_eks_cluster_auth.cluster.token
  sensitive = true

}



