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
  region = "us-east-1"
}

data "aws_vpc" "main" {
    id = "vpc-01e89344a2b59f694"
}

# resource "aws_ecs_service" "mouse" {
#     name = "mouse"

# }
