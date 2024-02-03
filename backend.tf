terraform {
  backend "s3" {
    bucket = "goblin228"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}