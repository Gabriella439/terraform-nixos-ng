variable "public_key_file" {
  type = string

  nullable = false
}

variable "region" {
  type = string

  default = "us-east-1"

  nullable = false
}

provider "aws" {
  region = var.region
}

terraform {
    required_version = ">= 1.3.0"

    required_providers {
        aws = {
           source = "hashicorp/aws"
           version = "~> 4.16"
        }
    }
}

resource "aws_security_group" "example" {
    ingress {
        from_port = 22

        to_port = 22

        protocol = "tcp"

        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_key_pair" "example" {
    public_key = file("${var.public_key_file}")
}

module "ami" {
    source = "github.com/Gabriella439/terraform-nixos-ng//ami"

    release = "22.11"

    region = var.region
}

resource "aws_instance" "example" {
    ami = module.ami.ami

    instance_type = "t3.micro"

    security_groups = [ aws_security_group.example.name ]

    key_name = aws_key_pair.example.key_name

    root_block_device {
        volume_size = 7
    }
}

module "nixos" {
    source = "github.com/Gabriella439/terraform-nixos-ng//nixos"

    host = "root@${aws_instance.example.public_ip}"

    flake = ".#default"

    arguments = [
      "--build-host",
      "root@${aws_instance.example.public_ip}",
    ]
}

output "public_dns" {
    value = aws_instance.example.public_dns
}
