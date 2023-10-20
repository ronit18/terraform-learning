provider "aws" {

  region = "ap-south-1"
}

provider "vault" {
  address          = "http://3.111.34.71:8200"
  skip_child_token = true
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "5047732b-620c-bb5b-7f9b-89bafc3645b5"
      secret_id = "091760f2-a267-9a65-a1a4-87348ceb8c7a"
    }
  }
}


data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test"
}


resource "aws_instance" "name" {
  tags = {
    Name = data.vault_kv_secret_v2.example.data["username"]
  }
  ami           = "ami-0287a05f0ef0e9d9a"
  instance_type = "t2.micro"
}
