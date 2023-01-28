variable "public_key_file" {
  type = string

  nullable = false
}

variable "region" {
  type = string

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
  # This is needed for the "nixos" module to manage the target host
  ingress {
    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = [ "0.0.0.0/0" ]
  }

  # This is needed if you build on the target host, like this example does, so
  # that the machine can download dependencies.  You would also need this if you
  # were to enable the `--use-substitutes` flag for `nixos-rebuild`.
  egress {
    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
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
    # You can build on another machine, including the target machine, by
    # enabling this option, but if you build on the target machine then make
    # sure that the firewall and security group permit outbound connections.
    "--build-host", "root@${aws_instance.example.public_ip}",
  ]
}

output "public_dns" {
  value = aws_instance.example.public_dns
}
