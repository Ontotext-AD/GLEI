#!/usr/bin/env bash
export JAVA_OPTS=-Xmx6G
for f in ../XMLsplit/*.xml
do
	new_file=$(echo ${f##*/} | sed "s/\.xml//") 
	echo "$new_file"
	xsparql convert-LEI-2016-cdf-2.1.xq input=$f | gzip -9 > ../RDF/$new_file.ttl.gz
done


