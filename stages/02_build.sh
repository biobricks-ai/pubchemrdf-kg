#!/usr/bin/env bash

set -euo pipefail

# Script to convert Turtle to RDF HDT

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

eval $( $localpath/vendor/biobricks-script-lib/activate.sh )

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

base_uri="http://rdf.ncbi.nlm.nih.gov/pubchem/"

# Set TMPDIR on same filesystem
export BUILD_TMPDIR=$buildpath/tmp
rm -rf -- "$BUILD_TMPDIR"
mkdir -p $BUILD_TMPDIR
# remove the above on exit
trap 'rm -rf -- "$BUILD_TMPDIR"' EXIT
export TMPDIR=$BUILD_TMPDIR

export buildpath_prestage=$buildpath/prestage
mkdir -p $buildpath_prestage

export downloadpath buildpath brickpath base_uri
find $downloadpath -type f -name '*.ttl.gz' | sort \
	| parallel -J ./parallel.prf --bar '
		set -euo pipefail;

		RDF_BASENAME="$(basename {} .ttl.gz)";
		RDF_DIR_REL="$(realpath -s --relative-to="$downloadpath" $(dirname {}))";
		RDF_HDT_DIR="$buildpath_prestage"/"$RDF_DIR_REL";
		RDF_HDT="$RDF_HDT_DIR"/"$RDF_BASENAME.hdt";

		mkdir -p $RDF_HDT_DIR;

		export RDF2HDTCAT_JAVA_OPTS="-Xmx24g";
		if [ ! -s $RDF_HDT ]; then
			echo "Processing {}"
			gzip -dk < {} \
				| rapper --input turtle --output ntriples - "$base_uri" \
				| rdf2hdtcat-parpipe $base_uri $RDF_HDT
		fi
		'

find $downloadpath/ -maxdepth 1 \
	-type f \! -name '*.ttl.gz' \
	-exec cp -v {} $brickpath/ \;

mv -v $buildpath_prestage/* $brickpath/
