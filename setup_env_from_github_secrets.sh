#!/bin/bash

# Script to create a .env file using GitHub Secrets

echo "Setting up environment variables from GitHub Secrets..."

# Check if GitHub Secrets are available
if [ -z "$BASE_URL" ] || [ -z "$RPC_CLIENT" ] || [ -z "$MIXPANEL_TOKEN" ] ||  [ -z "$AES_ENCRPTION_KEY" ]; then
  echo "Error: Some Github secret keys are missing."
  exit 1
fi

# Create the .env file
echo "BASE_URL=$BASE_URL" > .env
echo "RPC_CLIENT=$RPC_CLIENT" >> .env
echo "MIXPANEL_TOKEN=$MIXPANEL_TOKEN" >> .env
echo "AES_ENCRPTION_KEY=$AES_ENCRPTION_KEY" >> .env

echo ".env file created successfully from GitHub Secrets!"