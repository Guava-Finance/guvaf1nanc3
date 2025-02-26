#!/bin/bash

echo "Setting up environment variables..."

# Prompt the user for input
read -p "Enter BASE_URL: " BASE_URL
read -p "Enter RPC_CLIENT: " RPC_CLIENT
read -p "Enter MIXPANEL_TOKEN: " MIXPANEL_TOKEN
read -p "Enter AES_ENCRPTION_KEY: " AES_ENCRPTION_KEY

# Create the .env file
echo "BASE_URL=$BASE_URL" > .env
echo "RPC_CLIENT=$RPC_CLIENT" >> .env
echo "MIXPANEL_TOKEN=$MIXPANEL_TOKEN" >> .env
echo "AES_ENCRPTION_KEY=$AES_ENCRPTION_KEY" >> .env

echo ".env file created successfully!"