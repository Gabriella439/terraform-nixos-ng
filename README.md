# `terraform-nixos-ng`

This repository provides two Terraform modules:

- [`./nixos`](./nixos) - A Terraform module for auto-deploying a NixOS
  configuration to a target host

- [`./ami`](./ami) - A Terraform module for computing the correct NixOS AMI to use

## Example usage

You can find an example Terraform project using these modules in the
[`./example`](./example) directory.

## Motivation

The main reason this repository exists is because the `terraform-nixos`
repository is abandoned.  I wanted to simplify the upstream project in two
major ways:

- I wanted to simplify the deployment logic with `nixos-rebuild`

  … using the trick documented in [this blog post](https://www.haskellforall.com/2023/01/announcing-nixos-rebuild-new-deployment.html)

- I wanted to simplify the AMI module

  … by not requiring the list to be manually updated
 [like this](https://github.com/tweag/terraform-nixos/pull/73/files)

However, since the upstream project doesn't appear to be maintained I created my
own opinionated fork that is simpler than the original.  The main omissions
compared to the original are:

- No support for secrets management

  However, you can use this in conjunction with
  [`sops-nix`](https://github.com/Mic92/sops-nix) if you need secrets
  management

- No support for GCE images (yet)

  … mainly because I don't use Google Compute Engine, but I'd accept a PR to
  add support following the same pattern as the [`ami`](./ami) module.
