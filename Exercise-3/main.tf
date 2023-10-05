provider "aws" {
  region = "ap-south-1"

}

module "ec2_instance" {
  source        = "./modules/ec2_instance"
  name          = "my-ec2-instance"
  ami_value     = "ami-0d5d9d301c853a04a"
  instance_type = "t2.micro"
}
