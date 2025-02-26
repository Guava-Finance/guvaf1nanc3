#!/bin/bash

# Script to create a .env file using GitHub Secrets

echo "Setting up environment variables from GitHub Secrets..."

# Check if GitHub Secrets are available
if [ -z "$BASE_URL" ] || [ -z "$RPC_CLIENT" ] || [ -z "$MIXPANEL_TOKEN" ]; then
  echo "Error: GitHub Secrets are not set. Please ensure BASE_URL, RPC_CLIENT, and MIXPANEL_TOKEN are configured in your repository secrets."
  exit 1
fi

# Create the .env file
echo "BASE_URL=$BASE_URL" > .env
echo "RPC_CLIENT=$RPC_CLIENT" >> .env
echo "MIXPANEL_TOKEN=$MIXPANEL_TOKEN" >> .env

echo ".env file created successfully from GitHub Secrets!"