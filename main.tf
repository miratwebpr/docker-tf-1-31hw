terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  # We can specify credentials such as AWS Access key ID and Secret access key to access aws from our "local"
  # shared_credentials_file = "$HOME/.aws/credentials"
  region = var.aws_region
}

data "aws_availability_zones" "available" {
}

data "aws_vpc" "main" {
  id = "vpc-01e89344a2b59f694"
}

data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_subnet" "main" {
  for_each = toset(data.aws_subnets.main.ids)
  id = each.value
}
