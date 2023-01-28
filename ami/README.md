<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [external_external.ami](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `null` | no |
| <a name="input_release"></a> [release](#input\_release) | NixOS release | `string` | `"latest"` | no |
| <a name="input_system"></a> [system](#input\_system) | The system architecture<br><br>One of:<br><br>- x86\_64-linux<br>- aarch64-linux | `string` | `"x86_64-linux"` | no |
| <a name="input_virtualization_type"></a> [virtualization\_type](#input\_virtualization\_type) | The virtualization type of the AMI<br><br>One of:<br><br>- hvm-ebs<br>- hvm-s3<br>- pv-ebs<br>- pv-s3 | `string` | `"hvm-ebs"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami"></a> [ami](#output\_ami) | NixOS AMI |
<!-- END_TF_DOCS -->