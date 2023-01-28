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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.16 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.52.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ami"></a> [ami](#module\_ami) | github.com/Gabriella439/terraform-nixos-ng//ami | n/a |
| <a name="module_nixos"></a> [nixos](#module\_nixos) | ../nixos | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_instance.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [null_resource.example](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_key_file"></a> [private\_key\_file](#input\_private\_key\_file) | n/a | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | n/a | `string` | `"default"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_dns"></a> [public\_dns](#output\_public\_dns) | n/a |
<!-- END_TF_DOCS -->