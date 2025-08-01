#!/usr/bin/env bash

set -eu

# Script to download files

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Define the FTP URL for the dataset
# https://ftp.ncbi.nlm.nih.gov/pubchem/RDF/
# ftp://ftp.ncbi.nlm.nih.gov/pubchem/RDF/
ftp_url="ftp://ftp.ncbi.nlm.nih.gov/pubchem/RDF"

# Create the download directory
downloadpath="$localpath/download"
echo "Download path: $downloadpath"
mkdir -p "$downloadpath"

download_subdomain() {
	wget -r -A ttl.gz -N -nH --cut-dirs=2 "$@"
}

# Download files
(
	cd "$downloadpath";
	download_subdomain ${ftp_url}/anatomy
	download_subdomain ${ftp_url}/author
	download_subdomain ${ftp_url}/bioassay
	download_subdomain ${ftp_url}/book
	download_subdomain ${ftp_url}/cell
	download_subdomain ${ftp_url}/compound/general
	download_subdomain ${ftp_url}/concept
	download_subdomain ${ftp_url}/conserveddomain
	download_subdomain ${ftp_url}/cooccurrence
	download_subdomain ${ftp_url}/descriptor
	download_subdomain ${ftp_url}/disease
	download_subdomain ${ftp_url}/endpoint
	download_subdomain ${ftp_url}/gene
	download_subdomain ${ftp_url}/grant
	download_subdomain ${ftp_url}/inchikey
	download_subdomain ${ftp_url}/journal
	download_subdomain ${ftp_url}/measuregroup
	download_subdomain ${ftp_url}/organization
	download_subdomain ${ftp_url}/patent
	download_subdomain ${ftp_url}/pathway
	download_subdomain ${ftp_url}/protein
	download_subdomain ${ftp_url}/reference
	download_subdomain ${ftp_url}/source
	download_subdomain ${ftp_url}/substance
	download_subdomain ${ftp_url}/synonym
	download_subdomain ${ftp_url}/taxonomy
);
