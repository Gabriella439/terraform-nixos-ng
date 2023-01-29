variable "private_key_file" {
  type = string

  nullable = false
}

variable "region" {
  type = string

  nullable = false
}

variable "profile" {
  type = string

  nullable = false

  default = "default"
}

provider "aws" {
  profile = var.profile

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
  public_key = file("${var.private_key_file}.pub")
}

module "ami" {
  source = "../ami"

  release = "22.11"

  providers = {
    aws = aws
   }
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

# This ensures that the instance is reachable via `ssh` before we deploy NixOS
resource "null_resource" "example" {
  provisioner "remote-exec" {
    connection {
      host = aws_instance.example.public_dns

      private_key = file(var.private_key_file)
    }

    inline = [ ":" ]
  }
}

module "nixos" {
  source = "../nixos"

  host = "root@${aws_instance.example.public_ip}"

  flake = ".#default"

  arguments = [
    # You can build on another machine, including the target machine, by
    # enabling this option, but if you build on the target machine then make
    # sure that the firewall and security group permit outbound connections.
    "--build-host", "root@${aws_instance.example.public_ip}",
  ]

  ssh_options = "-o StrictHostKeyChecking=accept-new"

  depends_on = [ null_resource.example ]
}

output "public_dns" {
  value = aws_instance.example.public_dns
}
