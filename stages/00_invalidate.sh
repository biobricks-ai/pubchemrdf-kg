#!/usr/bin/env bash

# Script to download files

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Define the release URL for the dataset
checksum_url="https://ftp.uniprot.org/pub/databases/uniprot/current_release/rdf/RELEASE.metalink"

# Create the checksum directory
checksumpath="$localpath/checksum"
echo "Checksum path: $checksumpath"
mkdir -p "$checksumpath"
cd $checksumpath;

# Download file
wget -P $checksumpath $checksum_url

echo "Download done."
