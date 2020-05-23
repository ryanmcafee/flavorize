#! /usr/bin/pwsh

[CmdletBinding()]
Param(
    [string]$flavor = "azure",
    [string]$tf_workspace = (Invoke-Expression -Command "terraform workspace show").Trim(),
    [string]$kube_config_dir = "credentials/workspaces/${tf_workspace}/.kube",
    [Parameter(Position=0,Mandatory=$false,ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

#Initialize terraform
terraform init flavors/${flavor}

$provider_specific_variable_file=If (Test-Path "customizations/workspaces/${tf_workspace}/provider.tfvars" -PathType Leaf) {"customizations/workspaces/${tf_workspace}/provider.tfvars"} Else {"customizations/provider.tfvars"}
$flavor_variable_file=If (Test-Path "customizations/workspaces/${tf_workspace}/flavorize.tfvars" -PathType Leaf) {"customizations/workspaces/${tf_workspace}/flavorize.tfvars"} Else {"customizations/flavorize.tfvars"}

#Create the terraform plan
terraform destroy -var-file="${provider_specific_variable_file}" -var-file="${flavor_variable_file}" flavors/${flavor}
