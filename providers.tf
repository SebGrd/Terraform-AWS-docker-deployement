terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

variable "access_key" {
  type = string
  default = "ACCESS_KEY"
}

variable "secret_key" {
  type = string
  default = "SECRET_KEY"
}

provider "aws" {
  region = "eu-west-3"
  access_key = var.access_key
  secret_key = var.secret_key
}
