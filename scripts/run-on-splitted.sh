#!/usr/bin/env bash
for f in ../XMLsplit/*.xml
do
	new_file=$(echo ${f##*/} | sed "s/\.xml//") 
	echo "$new_file"
	java -Xmx6G -jar xsparql-cli-jar-with-dependencies.jar GLEI-convert.xsparql input=$f > ../RDF/$new_file.ttl
done


