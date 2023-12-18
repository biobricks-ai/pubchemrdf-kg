#!/usr/bin/env bash

# Script to download files

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Define the release URL for the dataset
metalink_url="https://ftp.uniprot.org/pub/databases/uniprot/current_release/rdf/RELEASE.metalink"

# Create the download directory
downloadpath="$localpath/download"
echo "Download path: $downloadpath"
mkdir -p "$downloadpath"
cd $downloadpath;

# Download files
aria2c -c -d $downloadpath $metalink_url
