# Example use of `terraform-nixos-ng`

This directory contains a `terraform` + NixOS project that deploys a minimal
NixOS machine to AWS.

In order to deploy this project you will need an AWS account and you will need
to
[obtain programmatic access keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html).
Once you have such access keys you can configure your computer to use them by
running:

```ShellSession
$ nix run github:NixOS/nixpkgs/22.11#awscli configure
```

You can then deploy this project by running:

```ShellSession
$ nix shell github:NixOS/nixpkgs/22.11#terraform
$ terraform init
$ terraform apply
```
