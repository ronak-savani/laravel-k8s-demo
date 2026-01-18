#!/bin/bash

# Define variables
SECRET_NAME="laravel-env-secret"
NAMESPACE="laravel-app"
ENV_FILE_PATH="./laravel-env-file"

# Check if file exists
if [ ! -f "$ENV_FILE_PATH" ]; then
    echo "Error: Environment file '$ENV_FILE_PATH' not found."
    exit 1
fi

# Command to create secret
# We use --from-file=.env=path/to/file to ensure the key in the secret is '.env'
COMMAND="kubectl create secret generic $SECRET_NAME -n $NAMESPACE --from-file=.env=$ENV_FILE_PATH --dry-run=client -o yaml | kubectl apply -f -"

echo "Executing: $COMMAND"
eval "$COMMAND"

if [ $? -eq 0 ]; then
    echo "Successfully created/updated secret '$SECRET_NAME' in namespace '$NAMESPACE'."
else
    echo "Failed to create secret."
    exit 1
fi
