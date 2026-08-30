terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "terraweek-aishwary-2026"
}

resource "aws_instance" "web" {
  ami           = "ami-0ac7b260cf76d8865"
  instance_type = "t3.micro"

  tags = {
    Name = "TerraWeek-Modified"
  }
}