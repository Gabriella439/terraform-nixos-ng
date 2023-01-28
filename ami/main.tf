variable "release" {
  type = string

  nullable = false

  default = "latest"

  description = "NixOS release"
}

variable "region" {
  type = string

  nullable = false

  description = "AWS region"
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

data "external" "ami" {
  program = [
    "${path.module}/ami.sh",
    path.module,
    var.release,
    var.region,
    var.system,
    var.virtualization_type,
  ]
}

output "ami" {
  description = "NixOS AMI"

  value = data.external.ami.result["ami"]
}
