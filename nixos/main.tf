variable "host" {
  type = string

  nullable = false

  description = <<-END
    The host to deploy to

    This can be any address that `ssh` accepts, including a `user@` prefix
    END
}

variable "arguments" {
  type = list(string)

  nullable = false

  default = []

  description = <<-END
    Extra arguments for the `nixos-rebuild` command

    Example: `["--build-host", "root@$${aws_instance.example.public_ip}"]`
    END
}

variable "ssh_options" {
  type = string

  default = null

  description = <<-END
    `ssh` options passed to `nixos-rebuild` via `NIX_SSHOPTS`
    END
}

variable "flake" {
  type = string

  nullable = false

  description = <<-END
    Flake URI for the NixOS configuration to deploy

    The flake URI needs to be suitable for `nixos-rebuild`, meaning that you
    should not include `nixosConfigurations` in the attribute path of the flake
    URI.  For example, if your NixOS configuration were actually stored at
    `.#nixosConfigurations.machine` within your flake then the flake URI that
    `nixos-rebuild` would expect is actually `.#machine`.
    END

  validation {
    condition = length(split("#", var.flake)) == 2

    error_message = "Invalid flake URI"
  }

  validation {
    condition = length(split("#", var.flake)) == 2 ? split("#", var.flake)[1] != "" : true

    # Note that nixos-rebuild supports empty attribute paths:
    #
    # https://github.com/NixOS/nixpkgs/blob/13645205311aa81dbc7c5adeee0382e38e52ee7c/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh#L362-L367
    #
    # … but does so by attempting to guess the attribute path from the hostname.
    # We could in theory attempt to match this behavior in terraform, but it's
    # simpler to disallow this and instead require the user to specify a
    # non-empty attribute path.
    error_message = "Empty flake attribute paths not supported"
  }
}

locals {
  components = split("#", var.flake)

  uri = local.components[0]

  attribute_path = local.components[1]

  real_flake = "${local.uri}#nixosConfigurations.${local.attribute_path}"
}

data "external" "instantiate" {
  program = [ "${path.module}/instantiate.sh", local.real_flake ]
}

resource "null_resource" "deploy" {
  triggers = {
    derivation = data.external.instantiate.result["path"]
  }

  provisioner "local-exec" {
    environment = {
      NIX_SSHOPTS = var.ssh_options
      NIXOS_SWITCH_USE_DIRTY_ENV = 1
    }

    interpreter = concat (
      [ "nix",
        "--extra-experimental-features", "nix-command flakes",
        "shell",
        "github:NixOS/nixpkgs/24.11#nixos-rebuild",
        "--command",
        "nixos-rebuild",
        "--fast",
        "--flake", var.flake,
        "--target-host", var.host,
      ],
      var.arguments
    )

    command = "switch"
  }
}
