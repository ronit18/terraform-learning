terraform {
  backend "s3" {
    bucket         = "ronitgandhi-terraform-state-bucket"
    key            = "ec-2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}


