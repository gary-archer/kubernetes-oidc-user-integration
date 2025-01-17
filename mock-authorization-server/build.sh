#!/bin/bash

#####################################
# Build the mock authorization server
#####################################

cd "$(dirname "${BASH_SOURCE[0]}")"

echo 'Installing Node.js dependencies ...'
npm install
if [ $? -ne 0 ]; then
  exit 1
fi

echo 'Generating a token signing keypair ...'
npm run generate-keypair
if [ $? -ne 0 ]; then
  exit 1
fi

echo 'Building the mock authorization server into a Docker image ...'
docker build -t mockauthorizationserver:1.0 .
if [ $? -ne 0 ]; then
  exit 1
fi

echo 'Loading the mock authorization server into the KIND Docker registry'
kind load docker-image mockauthorizationserver:1.0 --name=demo
if [ $? -ne 0 ]; then
  exit 1
fi

#
# If required, test the mock authorization server locally at a base URL of http://localhost:8443
# docker run -it -p 8443:8443 mockauthorizationserver:1.0
#
