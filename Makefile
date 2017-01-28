TTL    = GLEI-FIBO.ttl
PUML   = $(patsubst %.ttl, %.puml, $(TTL))
PNG    = $(patsubst %.ttl, %.png, $(TTL))
R2RML  = 

all : $(PNG) $(R2RML)

%.puml : %.ttl
	rdfpuml.bat $<

%.png : %.puml
	puml.bat $<

%.r2rml.ttl : %.ttl
	rdf2rml $< >$@
