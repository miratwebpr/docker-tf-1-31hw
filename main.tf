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
  vpc_id = data.aws_vpc.main.id
}

data "aws_subnet" "main" {
  count = "${length(data.aws_subnet_ids.main.ids)}"
  id = "${tolist(data.aws_subnet_ids.main.ids)[count.index]}"
}
