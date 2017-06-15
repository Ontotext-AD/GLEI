#!/usr/bin/env bash
for f in ../XMLsplit/*.xml
do
	new_file=$(echo ${f##*/} | sed "s/\.xml//") 
	echo "$new_file"
	java -Xmx6G -jar xsparql-cli-jar-with-dependencies.jar convert-LEI-2016-cdf-1.0.xq input=$f | gzip -9 > ../RDF/$new_file.ttl.gz
done


