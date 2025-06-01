#!/bin/bash

echo "Setting up environment variables..."

# Prompt the user for input
read -p "Enter BASE_URL: " BASE_URL
read -p "Enter RPC_CLIENT: " RPC_CLIENT
read -p "Enter MIXPANEL_TOKEN: " MIXPANEL_TOKEN
read -p "Enter AES_ENCRYPTION_KEY: " AES_ENCRYPTION_KEY
read -p "Enter AES_ENCRYPTION_IV: " AES_ENCRYPTION_IV
read -p "Enter DOJAH_API_ID: " DOJAH_API_ID
read -p "Enter DOJAH_PUBLIC_KEY: " DOJAH_PUBLIC_KEY
read -p "Enter DOJAH_WIDGET_ID: " DOJAH_WIDGET_ID
read -p "Enter PUB_NUB_SUBCRIBE_KEY: " PUB_NUB_SUBCRIBE_KEY
read -p "Enter PUB_NUB_PUBLISH_KEY: " PUB_NUB_PUBLISH_KEY
read -p "Enter AMPLITUDE_API_KEY: " AMPLITUDE_API_KEY
read -p "Enter SPL_TOKEN_URL: " SPL_TOKEN_URL

# Create the .env file
echo "BASE_URL=$BASE_URL" > .env
echo "RPC_CLIENT=$RPC_CLIENT" >> .env
echo "MIXPANEL_TOKEN=$MIXPANEL_TOKEN" >> .env
echo "AES_ENCRYPTION_KEY=$AES_ENCRYPTION_KEY" >> .env
echo "AES_ENCRYPTION_IV=$AES_ENCRYPTION_IV" >> .env
echo "DOJAH_API_ID=$DOJAH_API_ID" >> .env
echo "DOJAH_PUBLIC_KEY=$DOJAH_PUBLIC_KEY" >> .env
echo "DOJAH_WIDGET_ID=$DOJAH_WIDGET_ID" >> .env
echo "PUB_NUB_SUBCRIBE_KEY=$PUB_NUB_SUBCRIBE_KEY" >> .env
echo "PUB_NUB_PUBLISH_KEY=$PUB_NUB_PUBLISH_KEY" >> .env
echo "APP_ID=$APP_ID" >> .env
echo "AMPLITUDE_API_KEY=$AMPLITUDE_API_KEY" >> .env
echo "SPL_TOKEN_URL=$SPL_TOKEN_URL" >> .env

echo ".env file created successfully!"