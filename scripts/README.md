# Conversion scripts

## Who is Who

The scripts require chunking of the XML files. 
While chunking is done,
one should note that some nodes shouldn't be split halfway through.
In case this is ignored data might become inconsistent.

Nodes identified as such are:
* gleif:LOUSource
* lei:Record


### XSPARQL
The XSPARQL scripts include full conversion as per the mappings:
* convert-LEI-2015.xq
* convert-LEI-2016-cdf-2.1.xq

### LIXR
The LIXR implementation is incomplete. 
Some needed features proved to be missing/unusable:
* frag("foo") - which should output iterator variable
* concatenating text generators - Text generator is a LIXR (not scala) string variable (e.g. generated from XML or bound by user).
I was unable to construct the desirable URIs for inner nodes. 

## Registers
The conversion is implemented in TARQL.
Prior to running a new column should be created with the camelCase data for Jurisdiction.
The regex can be found in the TARQL.
```bash
cd scripts
tarql -d ',' --quotechar '"' registers.tarql ../registers/2017-01-11_registration-authorities-list-final-version-1.1.csv > ../RDF/registers.ttl
```


## Who owns who