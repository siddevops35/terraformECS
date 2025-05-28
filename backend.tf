terraform {
  backend "s3" {
    bucket = "test-bucket-terraform-sidd"      # Replace with your bucket name
    key    = "terraform.tfstate"      # Path to your state file
    region = "us-east-1"                       # Match your AWS region
    encrypt = true                             # Optional but recommended
  }
}

provider "aws" {
  region = "us-east-1"
}