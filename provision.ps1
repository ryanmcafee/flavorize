[CmdletBinding()]
Param(
    [string]$flavor = "azure",
    [string]$tf_workspace = (Invoke-Expression -Command "terraform workspace show").Trim(),
    [string]$kube_config_dir = "credentials/workspaces/${tf_workspace}/.kube",
    [string]$auto_approve = "false",
    [Parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
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

$provider_specific_variable_file = If (Test-Path "customizations/workspaces/${tf_workspace}/provider.tfvars" -PathType Leaf) { "customizations/workspaces/${tf_workspace}/provider.tfvars" } Else { "customizations/provider.tfvars" }
$flavor_variable_file = If (Test-Path "customizations/workspaces/${tf_workspace}/flavorize.tfvars" -PathType Leaf) { "customizations/workspaces/${tf_workspace}/flavorize.tfvars" } Else { "customizations/flavorize.tfvars" }

#Create the terraform plan
terraform plan -detailed-exitcode -var-file="${provider_specific_variable_file}" -var-file="${flavor_variable_file}" -out="${plan}" flavors/${flavor}

if ($LastExitCode -ne 1) {
    if ($auto_approve -eq "true") {
        #Apply the terraform plan
        terraform apply $plan
    }
    else {
        terraform apply -var-file="${provider_specific_variable_file}" -var-file="${flavor_variable_file}" flavors/${flavor}
    }
}

# Only run rest of script if terraform provisioning is successful
If ($LastExitCode -ne 1) {

    $preexisting_kubeconfig = (Resolve-Path -Path "~\.kube\config")

    # Create directory to store k8s credentials
    New-Item -ItemType Directory -Path $kube_config_dir -Force | Out-Null
    $new_kubeconfig = Join-Path -Path (Resolve-Path -Path $kube_config_dir) -ChildPath "config"

    # Write the kube_config file out to disk
    Invoke-Expression -Command "terraform output kube_config" | Out-File -FilePath $new_kubeconfig

    $kubeconfig_seperator = $IsWindows ? ';' : ':'

    # Set kubeconfig environment variable
    [System.Environment]::SetEnvironmentVariable('KUBECONFIG', "${new_kubeconfig}${kubeconfig_seperator}${preexisting_kubeconfig}")

    # Create the kube config directory under user path if it doesn't exist
    New-Item -ItemType Directory -Path ~\.kube -Force | Out-Null

    # Output the current kubeconfig to disk
    Invoke-Expression -Command "kubectl config view --raw" | Out-File -FilePath ~\.kube\config_new

    # Move the merged kubeconfig file to become standard one
    Move-Item ~\.kube\config_new ~\.kube\config -Force

    Copy-Item -Path ~\.kube\config -Destination "credentials/kubeconfig" -Force

    # Cleanup
    Remove-Item -Path "build/*" -ErrorAction Ignore -Recurse
    # Remove terraform output plan for consistent results and allow for seamless provider upgrades. 
    Remove-Item $plan -ErrorAction Ignore

    Write-Output "Merged kubeconfig files!"
    Write-Output "Merged kubeconfig file outputted to: credentials/kubeconfig"
    Write-Output "You're good to go!"
    Write-Output "Try running the following command: kubectl get pods --all-namespaces"
}