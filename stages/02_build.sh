#!/usr/bin/env bash

# Script to convert RDF .nt.gz to RDF HDT

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Set download path
downloadpath="$localpath/download"
echo "Download path: $downloadpath"

# Create build directory
buildpath="$localpath/build"
mkdir -p $buildpath
echo "Build path: $buildpath"

# Create brick directory
brickpath="$localpath/brick"
mkdir -p $brickpath
echo "Brick path: $brickpath"

base_uri="https://www.uniprot.org/"
mkdir $buildpath;
export buildpath brickpath base_uri
find $downloadpath -type f -name '*.rdf.xz' | sort \
	| parallel --bar '
		RDF=$buildpath/{/.};
		xz -T1 -dk < {} > "$RDF";
		$JENA_HOME/bin/riot --syntax=rdfxml --output=ntriples "$RDF" > "$RDF".nt;
		rm -v "$RDF";
		rdf2hdt -i -p -B "$base_uri" "$RDF".nt "$brickpath"/"$(basename "$RDF" .rdf).hdt";
		rm -v "$RDF".nt
		'
