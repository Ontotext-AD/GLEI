prefix leio: <http://data.ontotext.com/resource/leio/>
prefix glei: <http://data.ontotext.com/resource/glei/>
prefix dbo: <http://dbpedia.org/ontology/>
prefix dbr: <http://dbpedia.org/resource/>
prefix fibo-be-corp-corp: <http://www.omg.org/spec/EDMC-FIBO/BE/Corporations/Corporations/>
prefix fibo-be-le-fbo: <http://www.omg.org/spec/EDMC-FIBO/BE/LegalEntities/FormalBusinessOrganizations/>
prefix fibo-be-le-lei: <http://www.omg.org/spec/EDMC-FIBO/BE/LegalEntities/LEIEntities/>
prefix fibo-be-le-lp: <http://www.omg.org/spec/EDMC-FIBO/BE/LegalEntities/LegalPersons/>
prefix fibo-fbc-fct-breg: <http://www.omg.org/spec/EDMC-FIBO/FBC/FunctionalEntities/BusinessRegistries/>
prefix fibo-fbc-fct-ra: <http://www.omg.org/spec/EDMC-FIBO/FBC/FunctionalEntities/RegistrationAuthorities/>
prefix fibo-fnd-aap-agt: <http://www.omg.org/spec/EDMC-FIBO/FND/AgentsAndPeople/Agents/>
prefix fibo-fnd-arr-cls: <http://www.omg.org/spec/EDMC-FIBO/FND/Arrangements/ClassificationSchemes/>
prefix fibo-fnd-arr-id: <http://www.omg.org/spec/EDMC-FIBO/FND/Arrangements/IdentifiersAndIndices/>
prefix fibo-fnd-dt-fd: <http://www.omg.org/spec/EDMC-FIBO/FND/DatesAndTimes/FinancialDates/>
prefix fibo-fnd-plc-adr: <http://www.omg.org/spec/EDMC-FIBO/FND/Places/Addresses/>
prefix fibo-fnd-rel-rel: <http://www.omg.org/spec/EDMC-FIBO/FND/Relations/Relations/>
prefix fibo-fnd-law-jur: <http://www.omg.org/spec/EDMC-FIBO/FND/Law/Jurisdiction/>
prefix lcc-3166-1: <http://www.omg.org/spec/LCC/Countries/ISO3166-1-CountryCodes/>
prefix lcc-3166-2: <http://www.omg.org/spec/LCC/Countries/ISO3166-2-SubdivisionCodes/>
prefix lcc-639-1: <http://www.omg.org/spec/LCC/Languages/ISO639-1-LanguageCodes/>
prefix lcc-639-2: <http://www.omg.org/spec/LCC/Languages/ISO639-2-LanguageCodes/>
prefix lcc-cr: <http://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
prefix lcc-lr: <http://www.omg.org/spec/LCC/Languages/LanguageRepresentation/>
prefix puml: <http://plantuml.com/ontology#>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix vann: <http://purl.org/vocab/vann/>
prefix void: <http://rdfs.org/ns/void#>
prefix lei: <http://www.gleif.org/data/schema/leidata/2016>
prefix clei: <http://ns.c-lei.org/leidata/1>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix dc: <http://purl.org/dc/elements/1.1/>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix gleif: <http://www.gleif.org/concatenated-file/header-extension/1.1>
prefix rr: <http://www.gleif.org/data/schema/rr/2016>

import module namespace functx = "http://www.functx.com" at "functx-1.0-nodoc-2007-01.xq";


declare variable $input as xs:string external;
declare option saxon:output "method=text";

declare function local:relation($uri as xs:string, $record, $glei as xs:string){
    let $type := fn:concat($glei, "relation/type/", $record/rr:Relationship/rr:RelationshipType)
    construct {
        <{$uri}>  a fibo-fnd-ptyx-prc:RelationshipContext.
        <{$uri}>  fibo-fnd-rel-rel:hasContext <{$type}>.
        <{$type}> a fibo-fnd-rel-rel:Reference;
                  rdfs:comment {$record/rr:Relationship/rr:RelationshipType};
                  fibo-fnd-rel-rel:isMemberOf glei:relationship.
        glei:relationship a fibo-fnd-arr-cls:ClassificationScheme;
                          fibo-fnd-rel-rel:hasName "Relationship type".
    }
};

declare function local:period($uri as xs:string, $record, $glei as xs:string){
    for $period at $k in $record/rr:Relationship/rr:RelationshipPeriods/rr:RelationshipPeriod
    let $url  := fn:concat($uri, "/period/", $k)
    let $type := fn:concat($glei, "relation/period/type/", $period/rr:PeriodType)
    construct {
        <{$uri}> fibo-fnd-dt-fd:hasDatePeriod <{$url}>.
        <{$url}> a fibo-fnd-tim-tim:DatePeriod;
               fibo-fnd-dt-fd:hasEndDate {$period/rr:EndDate}^^xsd:dateTime;
               fibo-fnd-dt-fd:hasStartDate {$period/rr:StartDate}^^xsd:dateTime;
               fibo-fnd-rel-rel:isClassifiedBy <{$type}>.
        <{$type}> a fibo-fnd-rel-rel:Reference;
                  rdfs:comment {$period/rr:PeriodType}.
    }
};

declare function local:entry($uri as xs:string, $record, $glei as xs:string){
    let $entry      := fn:concat($uri, "/entry")
    let $document   := fn:concat($glei, "validation/document/", $record/rr:Registration/rr:ValidationDocuments)
    let $managing   := fn:concat($glei, $record/rr:Registration/rr:ManagingLOU)
    let $val_status := fn:concat($glei, "validation-status/")
    let $validation := fn:concat($val_status, $record/rr:Registration/rr:ValidationSources)
    construct {
        <{$uri}>        fibo-fnd-rel-rel:hasDenotation <{$entry}>.
        <{$entry}>      a fibo-fbc-fct-breg:BusinessRegistryEntry;
                        fibo-be-corp-corp:hasDateOfRegistration {$record/rr:Registration/rr:InitialRegistrationDate}^^xsd:dateTime;
                        fibo-fbc-fct-breg:hasRegistrationStatus {$record/rr:Registration/rr:RegistrationStatus};
                        fibo-fbc-fct-breg:hasRegistrationStatusRevisionDate {$record/rr:Registration/rr:LastUpdateDate}^^xsd:dateTime;
                        leio:nextRenewalDate {$record/rr:Registration/rr:NextRenewalDate}^^xsd:dateTime;
                        leio:validationDocument <{$document}>;
                        fibo-fbc-fct-ra:isRegisteredBy <{$managing}>;
                        leio:validationStatus <{$validation}>.
        <{$document}>   a fibo-fnd-rel-rel:Reference;
                        rdfs:comment {$record/rr:Registration/rr:ValidationDocuments}.
        <{$validation}> a fibo-fnd-rel-rel:Reference;
                        fibo-fnd-rel-rel:hasUniqueIdentifier {$record/rr:Registration/rr:ValidationSources};
                        fibo-fnd-rel-rel:isMemberOf <{$val_status}>.
        <{$val_status}> a fibo-fnd-arr-cls:ClassificationScheme;
                        fibo-fnd-rel-rel:hasName "LEI validation status".
    }
};

declare function local:nodes($uri as xs:string, $record, $glei as xs:string){
    let $startNodeID := if ($record/rr:Relationship/rr:StartNode/rr:NodeIDType = 'LEI')
                        then ($record/rr:Relationship/rr:StartNode/rr:NodeID)
                        else fn:concat("iso-17442", $record/rr:Relationship/rr:StartNode/rr:NodeID)
    let $endNodeID := if ($record/rr:Relationship/rr:EndNode/rr:NodeIDType = 'LEI')
                      then ($record/rr:Relationship/rr:EndNode/rr:NodeID)
                      else fn:concat("iso-17442", $record/rr:Relationship/rr:EndNode/rr:NodeID)
    construct {
        <{$uri}> leio:startNode <{fn:concat($glei, $startNodeID)}>;
                 leio:endNode   <{fn:concat($glei, $endNodeID)}>.
    }
};

declare function local:status($uri as xs:string, $record, $glei as xs:string){
    let $status := fn:concat($glei, "status/", $record/rr:Relationship/rr:RelationshipStatus)
    construct {
        <{$uri}>    leio:status <{$status}>.
        <{$status}> a fibo-fnd-rel-rel:Reference;
                    fibo-fnd-rel-rel:hasUniqueIdentifier {$record/rr:Relationship/rr:RelationshipStatus}.
    }
};

declare function local:qualifier($uri as xs:string, $record, $glei as xs:string){
    for $qual_rec at $k in $record/rr:Relationship/rr:RelationshipQualifiers/rr:RelationshipQualifier
    let $qual     := fn:concat($uri, "/qualifier/", $k)
    let $category := fn:concat($glei, "qualifier/", $qual_rec/rr:QualifierCategory)
    let $dim      := fn:concat($glei, "qualifier/", $qual_rec/rr:QualifierDimension)
    construct {
        <{$uri}>  leio:qualifier <{$qual}>.
        <{$qual}> a leio:Qualifier;
                  fibo-fnd-rel-rel:isClassifiedBy <{$category}>;
                  fibo-fnd-rel-rel:isClassifiedBy <{$dim}>.
        <{$category}> a fibo-fnd-rel-rel:Reference; rdfs:comment {$qual_rec/rr:QualifierCategory}.
        <{$dim}>      a fibo-fnd-rel-rel:Reference; rdfs:comment {$qual_rec/rr:QualifierDimension}.
    }
};

declare function local:quantifier($uri as xs:string, $record, $glei as xs:string){
    for $quan_rec at $k in $record/rr:Relationship/rr:RelationshipQuantifiers/rr:RelationshipQuantifier
    let $quan     := fn:concat($uri, "/quantifier/", $k)
    let $measure  := fn:concat($glei, "quantifier/", $quan_rec/rr:MeasurementMethod)
    let $units    := fn:concat($glei, "quantifier/", $quan_rec/rr:QuantifierUnits)
    construct {
        <{$uri}>  leio:quantifier <{$quan}>.
        <{$quan}> a leio:Quantifier;
                  fibo-fnd-math-amt:amount {$quan_rec/rr:QuantifierAmount}^^xsd:decimal;
                  fibo-fnd-rel-rel:isClassifiedBy <{$measure}>;
                  fibo-fnd-rel-rel:isClassifiedBy <{$units}>.
        <{$measure}> a fibo-fnd-rel-rel:Reference; rdfs:comment {$quan_rec/rr:MeasurementMethod}.
        <{$units}>   a fibo-fnd-rel-rel:Reference; rdfs:comment {$quan_rec/rr:QuantifierUnits}.
    }
};

for $record at $n in doc($input)/rr:RelationshipData/rr:RelationshipRecords/rr:RelationshipRecord
let $glei := "http://data.ontotext.com/resource/glei/"
let $relation := fn:concat($glei, "relation/", $n)
return (
    local:relation($relation, $record, $glei),
    local:period($relation, $record, $glei),
    local:entry($relation, $record, $glei),
    local:nodes($relation, $record, $glei),
    local:status($relation, $record, $glei),
    local:qualifier($relation, $record, $glei),
    local:quantifier($relation, $record, $glei)
)
