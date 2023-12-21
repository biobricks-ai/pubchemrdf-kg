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
export TMPDIR=$buildpath/tmp
mkdir -p $TMPDIR
export buildpath brickpath base_uri
find $downloadpath -type f -name '*.rdf.xz' | sort \
	| parallel -J ./parallel.prf --bar '
		RDF=$buildpath/{/.};
		RDF_NT_GZ="$RDF".nt.gz
		[ -f $RDF_NT_GZ ] || xz -T1 -dk < {} \
			| $JENA_HOME/bin/riot --syntax=rdfxml --stream=ntriples --compress | sponge $RDF_NT_GZ;
		[ -f $RDF_NT_GZ ] && rdf2hdt -i -p -B "$base_uri" $RDF_NT_GZ "$brickpath"/"$(basename "$RDF" .rdf).hdt" \
			&& rm -v $RDF_NT_GZ;
		'
