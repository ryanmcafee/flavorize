#Initialize terraform
terraform init

# Store where the terraform plan will be outputted
Set-Variable -Name plan -Value "out.plan"

#Create the terraform plan
terraform plan -var-file="customizations/terraform.tfvars" -var-file="customizations/terraform.common.tfvars" -out $plan

#Apply the terraform plan
terraform apply $plan

# Cleanup
Remove-Item -Path "build/*" -ErrorAction Ignore -Recurse

# Get what cloud_provider was used (also removes whitespace from variable)
$cloud_provider = (Invoke-Expression -Command "terraform output cloud_provider").Trim();

# Create directory to store k8s credentials
New-Item -ItemType "directory" -Path "credentials/${cloud_provider}/.kube" -Force | Out-Null

# Store relative path to where the generated kube config file is stored
Set-Variable -Name KubeConfigRelativePath -Value "credentials/${cloud_provider}/.kube/config"

# Write the kube_config file out to disk. Store in credentials folder under ${cloud_provider}/.kube
Invoke-Expression -Command "terraform output kube_config" | Out-File -FilePath $KubeConfigRelativePath

# Calculate and set path env variable to the kubeconfig file
# Necessary so kubectl will work regardless of directory and will ensure correct kubernetes cluster context is used../
Set-Item -Path env:KUBECONFIG ${Resolve-Path -Path $KubeConfigRelativePath}

# Remove terraform output plan for consistent results and allow for seamless provider upgrades. 
Remove-Item $plan -ErrorAction Ignore