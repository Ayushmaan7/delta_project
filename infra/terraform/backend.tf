terraform {
  backend "s3" {
    bucket         = "y-devops-simulator-terraform-state2"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

