terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

variable "release" {
  type = string

  nullable = false

  default = "latest"

  description = "NixOS release"
}

variable "system" {
  type = string

  nullable = false

  default = "x86_64-linux"

  description = <<-END
    The system architecture

    One of:

    - x86_64-linux
    - aarch64-linux
    END

  validation {
    condition = contains(["x86_64-linux", "aarch64-linux"], var.system)

    error_message = <<-END
      The system needs to be one of:

      - x86_64-linux
      - aarch64-linux
      END
  }
}

variable "virtualization_type" {
  type = string

  nullable = false

  default = "hvm-ebs"

  description = <<-END
    The virtualization type of the AMI

    One of:

    - hvm-ebs
    - hvm-s3
    - pv-ebs
    - pv-s3
    END

  validation {
    condition = contains(["hvm-ebs", "hvm-s3", "pv-ebs", "pv-s3"], var.virtualization_type)

    error_message = <<-END
      The virtualization type needs to be one of:

      - hvm-ebs
      - hvm-s3
      - pv-ebs
      - pv-s3
      END
  }
}

locals {
  root_device_type    = endswith(var.virtualization_type, "ebs") ? "ebs" : "instance-store"
  virtualization_type = startswith(var.virtualization_type, "hvm") ? "hvm" : "paravirtual"
  arch_isolated       = trimsuffix(var.system, "-linux")
  arch                = local.arch_isolated == "aarch64" ? "arm64" : local.arch_isolated
  nixos_ami_acc_id    = "080433136561" # Pretty sure all published AMIs so far have been from this account

  # This is the biggest issue with this method as this just grabs the newest release-like AMI.
  # Small tradeoff for a terraform native impl
  release = var.release == "latest" ? "\\d{2}\\.\\d{2}" : var.release

  # There are a bunch of 19.03 AMIs built after the one listed in 
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/amazon-ec2-amis.nix
  # so we add this extra bit in that case.
  extra_release_info = var.release == "19.03" ? "172286" : "\\d+"

  # If the user submits a more specific release that just XX.XX we need to modify our regex
  # so that it does prefix match on the more specific release version rather than built it
  # ourselves. 
  release_matcher = var.release == "" || length(regexall("^\\d{2}\\.\\d{2}$", local.release)) > 0 ? "${local.release}\\.${local.extra_release_info}\\.\\S+" : "${local.release}*"
}

data "aws_ami" "ami" {
  most_recent        = true
  include_deprecated = true
  name_regex         = "^(NixOS|nixos)-${local.release_matcher}"

  filter {
    name   = "name"
    values = ["NixOS-${local.release}*", "nixos-${local.release}*"]
  }

  filter {
    name   = "owner-id"
    values = [local.nixos_ami_acc_id]
  }

  filter {
    name   = "virtualization-type"
    values = [local.virtualization_type]
  }

  filter {
    name   = "root-device-type"
    values = [local.root_device_type]
  }

  filter {
    name   = "architecture"
    values = [local.arch]
  }
}

output "ami" {
  description = "NixOS AMI"

  value = data.aws_ami.ami.image_id
}
