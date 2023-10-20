provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "tf-ec2-instance" {
  ami           = var.ami
  instance_type = var.instance_type

}
