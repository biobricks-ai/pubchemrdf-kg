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
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/compound/general
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/substance
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/descriptor
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/synonym
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/inchikey
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/bioassay
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/measuregroup
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/endpoint
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/protein
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/pathway
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/conserveddomain
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/gene
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/source
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/concept
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/reference
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/disease
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/taxonomy
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/cell
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/author
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/book
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/journal
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/grant
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/organization
	wget -r -A ttl.gz -nH --cut-dirs=2 ${ftp_url}/cooccurrence
);
