#! /usr/bin/pwsh

[CmdletBinding()]
Param(
    [string]$flavor = "azure",
    [string]$tf_workspace = (Invoke-Expression -Command "terraform workspace show").Trim(),
    [string]$kube_config_dir = "credentials/workspaces/${tf_workspace}/.kube",
    [Parameter(Position=0,Mandatory=$false,ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

If (-NOT  ($flavor -eq $tf_workspace)) {
    Write-Output "Warning: Terraform workspace and chosen flavor don't match"
    Write-Output "This may result in your configuration getting overwritten"
    Write-Output "To resolve this run: terraform workspace new ${flavor}"
}

If ($flavor -like "azure") {
    # Check if the ssh public key (needed for azure aks provisioning already exists)
    If (-NOT (Test-Path "credentials/ssh/id_rsa.pub")) {
        # Create credentials/ssh directory if it doesn't already exist
        New-Item -ItemType Directory -Path credentials/ssh -Force | Out-Null
        # Generate the ssh key
        ssh-keygen -t rsa -b 2048 -f credentials/ssh/id_rsa -N '""'
    }
    
}

#Initialize terraform
terraform init flavors/${flavor}

# Store where the terraform plan will be outputted
Set-Variable -Name plan -Value "out.plan"

$provider_specific_variable_file=If (Test-Path "customizations/workspaces/${tf_workspace}/provider.tfvars" -PathType Leaf) {"customizations/workspaces/${tf_workspace}/provider.tfvars"} Else {"customizations/provider.tfvars"}
$flavor_variable_file=If (Test-Path "customizations/workspaces/${tf_workspace}/flavorize.tfvars" -PathType Leaf) {"customizations/workspaces/${tf_workspace}/flavorize.tfvars"} Else {"customizations/flavorize.tfvars"}

#Create the terraform plan
terraform plan -var-file="${provider_specific_variable_file}" -var-file="${flavor_variable_file}" -out="${plan}" flavors/${flavor}

#Apply the terraform plan
terraform apply $plan

# Create directory to store k8s credentials
New-Item -ItemType Directory -Path $kube_config_dir -Force | Out-Null

# Write the kube_config file out to disk
Invoke-Expression -Command "terraform output kube_config" | Out-File -FilePath "${kube_config_dir}/config"

# Calculate and set path env variable to the kubeconfig file
# Necessary so kubectl will work regardless of directory and will ensure correct kubernetes cluster context is used../
Set-Item -Path env:KUBECONFIG (Resolve-Path -Path "${kube_config_dir}/config")

# Cleanup
Remove-Item -Path "build/*" -ErrorAction Ignore -Recurse
# Remove terraform output plan for consistent results and allow for seamless provider upgrades. 
Remove-Item $plan -ErrorAction Ignore
