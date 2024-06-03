terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.29.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13.1"
    }
  }
  
  #To save terraform state in S3
  backend "s3" {
    bucket = "terraform-bucket"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  #region = var.region
  region = "us-east-1"
}

#This block specifies the Kubernetes cluster's endpoint, authentication token, and cluster CA certificate. These are necessary for Terraform to interact with the Kubernetes cluster.
provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.auth.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
}

#This block retrieves information about available AWS availability zones in the specified region ("us-east-1") and stores it in a data source named "az".
data "aws_availability_zones" "az" {
  state = "available"
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}
