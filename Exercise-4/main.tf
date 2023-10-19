provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "terraform-ec2" {
  tags = {
    Name = "my-ec2-instance"
  }
  ami           = "ami-099b3d23e336c2e83"
  instance_type = "t2.micro"
}
resource "aws_instance" "terraform-ec2-2" {
  tags = {
    Name = "my-ec2-instance-2"
  }
  ami           = "ami-099b3d23e336c2e83"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "terraform-tf-state-bucket" {
  bucket = "ronitgandhi-terraform-state-bucket"
}

resource "aws_dynamodb_table" "terraform-lock" {
  name         = "terraform-lock"
  billing_mode = "pay_per_request"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
