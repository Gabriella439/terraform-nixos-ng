<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.deploy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [external_external.instantiate](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arguments"></a> [arguments](#input\_arguments) | Extra arguments for the nixos-rebuild command"<br><br>Example: `["--build-host", "root@${aws_instance.example.public_ip}"]` | `list(string)` | `[]` | no |
| <a name="input_flake"></a> [flake](#input\_flake) | Flake URI for the NixOS configuration to deploy<br><br>The flake URI needs to be suitable for `nixos-rebuild`, meaning that you<br>should not include `nixosConfigurations` in the attribute path of the flake<br>URI.  For example, if your NixOS configuration were actually stored at<br>`.#nixosConfigurations.machine` within your flake then the flake URI that<br>`nixos-rebuild` would expect is actually `.#machine`. | `string` | n/a | yes |
| <a name="input_host"></a> [host](#input\_host) | The host to deploy to<br><br>This can be any address that `ssh` accepts, including a `user@` prefix | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->