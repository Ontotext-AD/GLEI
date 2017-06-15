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
prefix lei: <http://www.leiroc.org/data/schema/leidata/2014>
prefix clei: <http://ns.c-lei.org/leidata/1>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix dc: <http://purl.org/dc/elements/1.1/>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>

import module namespace functx = "http://www.functx.com" at "functx-1.0-nodoc-2007-01.xq";


declare variable $input as xs:string external;
declare option saxon:output "method=text";


declare function local:address($uri as xs:string, $record, $record_uri as xs:string, $predicate as xs:string){
    let $x := $uri
    construct {
        <{$record_uri}> <{$predicate}> <{$uri}>.
        <{$uri}> a fibo-fbc-fct-breg:RegistrationAddress;
                 dc:language {$record/lei:Line1/@xml:lang/string()};
                 fibo-fbc-fct-breg:hasAddressLine1            {$record/lei:Line1};
                 fibo-fbc-fct-breg:hasAddressLine2            {$record/lei:Line2};
                 fibo-fbc-fct-breg:hasAddressLine3            {$record/lei:Line3};
                 fibo-fbc-fct-breg:hasAddressLine4            {$record/lei:Line4};
                 fibo-fbc-fct-breg:hasCity                    {$record/lei:City};
                 fibo-fbc-fct-breg:hasPostalCode              {$record/lei:PostalCode};
                 leio:countryCode                             {$record/lei:Country};
                 leio:subdivisionCode                         {$record/lei:Region};
    }
};

declare function local:lei_lei($uri as xs:string, $record, $uri_record as xs:string){
    let $x := $uri
    construct {
        <{$uri_record}> fibo-fnd-aap-agt:isIdentifiedBy <{$uri}>.
        <{$uri}> a fibo-fbc-fct-ra:RegistryIdentifier;
                 a fibo-be-le-lei:LegalEntityIdentifier;
                 fibo-fnd-rel-rel:hasUniqueIdentifier   {$record/lei:LEI};
                 fibo-fnd-arr-id:isIndexTo glei:;
    }
};

declare function local:registrationManaging($uri as xs:string, $record){
    let $url := fn:concat("http://data.ontotext.com/resource/glei/", $record/lei:Registration/lei:ManagingLOU/text())
    construct {
        <{$url}> a fibo-fbc-fct-breg:BusinessRegistrationAuthority;
                 fibo-fnd-rel-rel:manages <http://data.ontotext.com/resource/glei/>;
    }
};

declare function local:entry($uri as xs:string, $record){
    let $entry := fn:concat($uri, "/entry")
    let $registrationManaging := fn:concat("http://data.ontotext.com/resource/glei/", $record/lei:Registration/lei:ManagingLOU/text())
    let $glei := fn:concat($uri, "/lei")
    construct {
        <{$entry}> a fibo-fbc-fct-breg:BusinessRegistryEntry;
                   fibo-be-corp-corp:hasDateOfRegistration                {$record/lei:Registration/lei:InitialRegistrationDate/text()}^^xsd:dateTime;
                   fibo-fbc-fct-breg:hasRegistrationStatus                {$record/lei:Registration/lei:RegistrationStatus};
                   fibo-fbc-fct-breg:hasRegistrationStatusRevisionDate    {$record/lei:Registration/lei:LastUpdateDate/text()}^^xsd:dateTime;
                   leio:nextRenewalDate                                   {$record/lei:Registration/lei:NextRenewalDate/text()}^^xsd:dateTime;
                   leio:validationSources                                 {$record/lei:Registration/lei:ValidationSources};
                   fibo-fbc-fct-ra:isRegisteredBy                         <{$registrationManaging}>;
                   fibo-fnd-rel-rel:comprises                             <{$glei}>;
    }
};

declare function local:lei_identifier($uri as xs:string, $record, $uri_record as xs:string){
    let $x := $uri
    construct {
        <{$uri_record}> fibo-fnd-aap-agt:isIdentifiedBy <{$uri}>.
        <{$uri}> a                                    fibo-be-corp-corp:RegistrationIdentifier;
                 fibo-fnd-rel-rel:hasUniqueIdentifier {$record/lei:Entity/lei:BusinessRegisterEntityID};
                 rdfs:comment                         {$record/lei:Entity/lei:BusinessRegisterEntityID/@register/string()};
    }
};


declare function local:otherNames($uri as xs:string, $record){
    let $otherName := $uri
    construct {
        <{$uri}> leio:autoAsciiTransliteratedLegalName      {$record[@type="AUTO_ASCII_TRANSLITERATED_LEGAL"]};
                 leio:autoRomanizedLegalName                {$record[@type="AUTO_ROMANIZED_LEGAL"]};
                 leio:otherLegalName                        {$record[@type="OTHER_LEGAL"]};
                 leio:preferredAsciiTransliteratedLegalName {$record[@type="PREFERRED_ASCII_TRANSLITERATED_LEGAL"]};
    }
};

declare function local:LEI ($uri as xs:string, $record) {
    let $denotation := fn:concat($uri, "/entry")
    let $lei        := fn:concat($uri, "/lei")
    let $le_n       := fn:concat($uri, "/id", "/1")
    construct {
        <{$uri}> a                                          fibo-be-le-lp:LegalEntity;
                 fibo-be-corp-corp:hasLegalFormAbbreviation {$record/lei:Entity/lei:LegalForm[.!='OTHER']
                                                                                             [.!='n/a']
                                                                                             [.!='Oher']
                                                                                             [.!='Other']
                                                                                             [.!='NO APPLICA']};
                 fibo-fnd-rel-rel:hasLegalName              {$record/lei:Entity/lei:LegalName};
                 leio:expirationDate                        {$record/lei:Entity/lei:EntityExpirationDate/text()}^^xsd:dateTime; 
                 leio:expirationReason                      {$record/lei:Entity/lei:EntityExpirationReason};
                 leio:legalJurisdictionCode                 {$record/lei:Entity/lei:LegalJurisdiction};
                 leio:status                                {$record/lei:Entity/lei:EntityStatus};
                 fibo-fnd-rel-rel:hasDenotation             <{$denotation}>.
        {
            for $otherName in $record/lei:Entity/lei:OtherEntityNames/lei:OtherEntityName return
              local:otherNames($uri, $otherName),
            local:lei_lei($lei, $record, $uri),
            if ($record/lei:Entity/lei:BusinessRegisterEntityID/@register/string()!="N/A") then
                local:lei_identifier($le_n, $record, $uri)
            else ()
        }
    }
};

declare function local:downloadURL($uri as xs:string, $record) {
    let $url := fn:concat($uri, $record/clei:DownloadURL/text())
    construct {
        <{$url}> a leio:DownloadFile;
                 leio:contentDate    {$record/clei:ContentDate/text()}^^xsd:dateTime;
                 leio:downloadDate   {$record/clei:DownloadDate/text()}^^xsd:dateTime;
                 leio:isSchemaValid  {$record/clei:SchemaValid/text()}^^xsd:boolean;
                 leio:originator     {$record/clei:Originator};
                 leio:recordCount    {$record/clei:RecordCount/text()}^^xsd:integer;
    }
};

declare function local:managingLOU($uri as xs:string, $record, $download as xs:string) {
    let $url := fn:concat($uri, $record/@managingLOU/string())
    construct {
        <{$url}> a fibo-fbc-fct-breg:BusinessRegistrationAuthority;
                 leio:recordCount         {$record/text()}^^xsd:integer;
                 leio:downloadFile        <{fn:concat($uri, $download)}>;
                 fibo-fnd-rel-rel:manages <http://data.ontotext.com/resource/glei/>
    }
};

declare function local:glei_master() {
    let $url := ""
    construct {
        glei: a fibo-fbc-fct-breg:BusinessRegistry;
              fibo-fnd-rel-rel:hasName "Global GLEI register";
    }
};

let $dummy := "FD"
return(
for $record in doc($input)/lei:LEIData/lei:LEIRecords/lei:LEIRecord
let $uri := fn:concat("http://data.ontotext.com/resource/glei/", $record/lei:LEI/text())
let $headquarters    := fn:concat($uri, "/address/headquarters")
let $legal           := fn:concat($uri, "/address/legal")
let $hq_predicate    := fn:concat("http://www.omg.org/spec/EDMC-FIBO/FBC/FunctionalEntities/BusinessRegistries/", "hasHeadquartersAddress")
let $legal_predicate := fn:concat("http://www.omg.org/spec/EDMC-FIBO/FND/Places/Addresses/", "hasAddressOfLegalFormation")
return (
    local:LEI($uri, $record),
    local:entry($uri, $record),
    local:registrationManaging($uri, $record),
    local:address($headquarters, $record/lei:Entity/lei:HeadquartersAddress, $uri, $hq_predicate),
    local:address($legal       , $record/lei:Entity/lei:LegalAddress,        $uri, $legal_predicate),
    for $legal at $x in $record/lei:OtherAddresses[@type="LEGAL_ADDRESS"] return
        local:address(fn:concat($uri, "/address/legal/", $x), $legal, $uri, $legal_predicate),
    for $hq at $x in $record/lei:OtherAddresses[@type="HEADQUARTERS_ADDRESS"] return
        local:address(fn:concat($uri, "/address/headquarters/", $x), $hq, $uri, $hq_predicate)
),
for $lou_file in doc($input)/lei:LEIData/lei:LEIHeader/lei:Extension/clei:LOUFiles/clei:LOUFile
let $uri := "http://data.ontotext.com/resource/glei/"
return (
    for $manage in $lou_file/clei:ManagingLOUCount return
        local:managingLOU($uri, $manage, $lou_file/clei:DownloadURL/text()),
    local:downloadURL("http://data.ontotext.com/resource/glei/", $lou_file)
),
local:glei_master()
)


