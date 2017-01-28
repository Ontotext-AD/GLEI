# LOOKUP leio:legalJurisdictionCode to make fibo-be-le-lp:isOrganizedIn
insert {
  ?entity fibo-be-le-lp:isOrganizedIn ?jurisdiction.
  ?jurisdiction a fibo-fnd-law-jur:Jurisdiction.
} where {
  ?entity leio:legalJurisdictionCode ?code.
  [] lcc-cr:hasSubdivisionTag|lcc-cr:hasCountryTag ?code; lcc-lr:identifies ?jurisdiction
};

# LOOKUP dc:language to make dbo:language
insert {
  ?address dbo:language ?lang
} where
  ?address dc:langauge ?code.
  [] lcc-lr:hasLanguageTag ?code; lcc-lr:identifies ?lang
};

# LOOKUP leio:subdivisionCode to make fibo-fbc-fct-breg:hasSubdivision
insert {
  ?address fibo-fbc-fct-breg:hasSubdivision ?subdivision
} where {
  ?address leio:subdivisionCode ?code.
  [] lcc-cr:hasSubdivisionTag ?code; lcc-lr:identifies ?subdivision
};

# LOOKUP leio:countryCode to make fibo-fbc-fct-breg:hasCountry
insert {
  ?address fibo-fbc-fct-breg:hasCountry ?country
} where {
  ?address leio:countryCode ?code.
  [] lcc-cr:hasCountryTag ?code; lcc-lr:identifies ?country
};
