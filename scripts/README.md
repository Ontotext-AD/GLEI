# Conversion scripts
The scripts require chunking of the XML files. 
While chunking is done,
one should note that some nodes shouldn't be split halfway through.
In case this is ignored data might become inconsistent.

Nodes identified as such are:
* gleif:LOUSource
* lei:Record

## XSPARQL
The XSPARQL scripts include full conversion as per the mappings:
* convert-LEI-2015.xq
* convert-LEI-2016-cdf-2.1.xq

## LIXR
The LIXR implementation is incomplete. 
Some needed features proved to be missing/unusable:
* frag("foo") - which should output iterator variable
* concatenating text generators - Text generator is a LIXR (not scala) string variable (e.g. generated from XML or bound by user).
I was unable to construct the desirable URIs for inner nodes. 