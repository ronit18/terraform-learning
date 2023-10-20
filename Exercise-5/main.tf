provider "aws" {
  region = "ap-south-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "tf-keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
  tags = {
    Name = "myvpc"
  }

}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "websg" {
  name   = "websg"
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "websg"
  }

  ingress {
    description = "HTTP From vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH From vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "server" {
  tags = {
    Name = "server"
  }
  ami                    = "ami-0287a05f0ef0e9d9a"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mykeypair.key_name
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.sub1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip

  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {

    inline = [
      "echo 'hello from the remove instance'",
      "sudo apt update -y",
      "sudo apt install -y python3-pip",
      "cd /home/ubuntu",
      "pip3 install flask",
      "python3 app.py &"
    ]
  }

}

output "aws_instance_public_ip" {
  value = aws_instance.server.public_ip

}
