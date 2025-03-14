#!/bin/bash

# Script to create a .env file using GitHub Secrets

echo "Setting up environment variables from GitHub Secrets..."

# Check if GitHub Secrets are available
if [ -z "$BASE_URL" ] || [ -z "$RPC_CLIENT" ] || [ -z "$MIXPANEL_TOKEN" ] ||  [ -z "$AES_ENCRYPTION_KEY" ] ||  [ -z "$DOJAH_API_ID" ] ||  [ -z "$DOJAH_PUBLIC_KEY" ] ||  [ -z "$DOJAH_WIDGET_ID" ]; then
  echo "Error: Some Github secret keys are missing."
  exit 1
fi

# Create the .env file
echo "BASE_URL=$BASE_URL" > .env
echo "RPC_CLIENT=$RPC_CLIENT" >> .env
echo "MIXPANEL_TOKEN=$MIXPANEL_TOKEN" >> .env
echo "AES_ENCRYPTION_KEY=$AES_ENCRYPTION_KEY" >> .env
echo "DOJAH_API_ID=$DOJAH_API_ID" >> .env
echo "DOJAH_PUBLIC_KEY=$DOJAH_PUBLIC_KEY" >> .env
echo "DOJAH_WIDGET_ID=$DOJAH_WIDGET_ID" >> .env

echo ".env file created successfully from GitHub Secrets!"