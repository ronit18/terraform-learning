provider "aws" {
  region = "ap-south-1"
}

variable "ami" {
  description = "AMI to be used"

}

variable "instance_type" {
  description = "Instance type"

  type = map(string)
  default = {
    default = "t2.micro"
    dev     = "t2.small"
    prod    = "t2.medium"
  }

}

module "ec2_instance" {
  source        = "./modules/ec2_instances"
  ami           = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}
