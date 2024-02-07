#!/usr/bin/env bash

# Script to download files

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Define the FTP URL for the dataset
# https://ftp.ncbi.nlm.nih.gov/pubchem/RDF/
# ftp://ftp.ncbi.nlm.nih.gov/pubchem/RDF/
ftp_url="ftp://ftp.ncbi.nlm.nih.gov/pubchem/RDF/"

# Create the download directory
downloadpath="$localpath/download"
echo "Download path: $downloadpath"
mkdir -p "$downloadpath"

# Download files
(
	cd "$downloadpath";
	lftp -c "connect $ftp_url ; mirror --verbose -c -P $ftp_url"; \
);
