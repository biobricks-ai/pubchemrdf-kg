#!/usr/bin/env bash

# Script to download files

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Define the VoID URL for the dataset
void_url="https://ftp.ncbi.nlm.nih.gov/pubchem/RDF/void.ttl"

# Create the VoID directory
voidpath="$localpath/void"
echo "VoID path: $voidpath"
mkdir -p "$voidpath"

# Download file
wget -P $voidpath $void_url

echo "Download done."
