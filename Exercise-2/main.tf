provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "terraform-ec2" {
  tags = {
    Name = var.Name
  }
  ami           = "ami-05552d2dcf89c9b24"
  instance_type = "t2.micro"
}
