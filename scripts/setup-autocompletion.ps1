Install-Module -Name PSKubectlCompletion
Import-Module PSKubectlCompletion
Set-Alias k -Value kubectl
Set-Alias h -Value helm
Register-KubectlCompletion