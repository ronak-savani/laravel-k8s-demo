# Script to create Kubernetes Secret for Laravel Environment

# Define variables
$SecretName = "laravel-env-secret"
$Namespace = "laravel-app"
$EnvFilePath = ".\laravel-env-file"

# Check if file exists
if (-Not (Test-Path $EnvFilePath)) {
    Write-Error "Error: Environment file '$EnvFilePath' not found."
    exit 1
}

# command to create secret
# We use --from-file=.env=path/to/file to ensure the key in the secret is '.env' 
# as expected by the subPath mount in deployment.yaml
$Command = "kubectl create secret generic $SecretName -n $Namespace --from-file=.env=$EnvFilePath --dry-run=client -o yaml | kubectl apply -f -"

Write-Host "Executing: $Command"
Invoke-Expression $Command

if ($?) {
    Write-Host "Successfully created/updated secret '$SecretName' in namespace '$Namespace'."
} else {
    Write-Error "Failed to create secret."
}
