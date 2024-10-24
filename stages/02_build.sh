#!/usr/bin/env bash

set -euo pipefail

# Script to convert Turtle to RDF HDT

export LC_ALL="C"

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

export PARALLEL_COLOPTS="--colsep \t --header :"

process_rdf_group() {
	group_file="$1"

	export NAME=$( head -2 $group_file | parallel $PARALLEL_COLOPTS 'echo {=name uq() =}' ) ;
	export GRAPH_URI=$( head -2 $group_file | parallel $PARALLEL_COLOPTS 'echo {=graph uq() =}' ) ;
	echo $NAME $GRAPH_URI >&2 ;

	export RDF_BASENAME="$NAME";
	export RDF_HDT_DIR="$buildpath_prestage"/"$RDF_BASENAME";
	export RDF_HDT="$RDF_HDT_DIR"/"pc_$RDF_BASENAME.hdt";

	if [ -s $RDF_HDT ]; then
		return
	fi

	mkdir -p $RDF_HDT_DIR;

	export RDF2HDTCAT_JAVA_OPTS="-Xmx24g";

	< $group_file \
	parallel --line-buffer -J ./parallel.prf --bar $PARALLEL_COLOPTS '
		set -euo pipefail;

		FILE=download/{=file uq() =}
		if [ -r $FILE ]; then
			echo "Processing $FILE" >&2
			gzip -dk < $FILE \
				| rapper --input turtle --output ntriples - "$GRAPH_URI"
		else
			echo "Skipping $FILE: does not exist" >&2
		fi
	' \
	| rdf2hdtcat-parpipe $GRAPH_URI $RDF_HDT
}
export -f process_rdf_group;

$JENA_HOME/bin/jena arq.sparql \
	--quiet \
	--data=download/RDF/void.ttl \
	--query=stages/pubchem-subsets.rq \
	--results=TSV \
	| grep -v '^ERROR StatusConsoleListener' \
	| perl -pe '$. == 1 and tr/?//d' \
	| parallel -u -j1 -kN1 --blocksize 10M \
		$PARALLEL_COLOPTS --group-by name --cat '
		process_rdf_group {} \
	'

#| perl -pe 'undef $_ if $. > 1 && ! /"gene"/' \

find $downloadpath/ -maxdepth 1 \
	-type f \! -name '*.ttl.gz' \
	-exec cp -v {} $brickpath/ \;

mv -v $buildpath_prestage/* $brickpath/
