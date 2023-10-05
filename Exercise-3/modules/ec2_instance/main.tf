provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "terraform_exercise_3" {
  tags = {
    Name = var.name
  }
  ami           = var.ami_value
  instance_type = var.instance_type
}
