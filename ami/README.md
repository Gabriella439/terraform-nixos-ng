<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.16 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.16 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ami.ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_release"></a> [release](#input\_release) | NixOS release | `string` | `"latest"` | no |
| <a name="input_system"></a> [system](#input\_system) | The system architecture<br><br>One of:<br><br>- x86\_64-linux<br>- aarch64-linux | `string` | `"x86_64-linux"` | no |
| <a name="input_virtualization_type"></a> [virtualization\_type](#input\_virtualization\_type) | The virtualization type of the AMI<br><br>One of:<br><br>- hvm-ebs<br>- hvm-s3<br>- pv-ebs<br>- pv-s3 | `string` | `"hvm-ebs"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami"></a> [ami](#output\_ami) | NixOS AMI |
<!-- END_TF_DOCS -->