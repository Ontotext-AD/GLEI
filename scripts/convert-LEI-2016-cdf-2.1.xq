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

import module namespace functx = "http://www.functx.com" at "functx-1.0-nodoc-2007-01.xq";


declare variable $input as xs:string external;
declare option saxon:output "method=text";


declare function local:address($uri as xs:string, $record, $record_uri as xs:string, $predicate as xs:string, $schema as xs:string){
    let $x := $uri
    construct {
        <{$record_uri}> <{$predicate}> <{$uri}>.
        <{$uri}> a fibo-fbc-fct-breg:RegistrationAddress;
                 dc:language {$record/lei:Line1/@xml:lang/string()};
                 fibo-fbc-fct-breg:hasAddressLine1            {$record/lei:FirstAddressLine};
                 fibo-fbc-fct-breg:hasAddressLine2            {$record/lei:AdditionalAddressLine[1]};
                 fibo-fbc-fct-breg:hasAddressLine3            {$record/lei:AdditionalAddressLine[2]};
                 fibo-fbc-fct-breg:hasAddressLine4            {$record/lei:AdditionalAddressLine[3]};
                 fibo-fbc-fct-breg:hasCity                    {$record/lei:City};
                 fibo-fbc-fct-breg:hasPostalCode              {$record/lei:PostalCode};
                 leio:countryCode                             {$record/lei:Country};
                 leio:subdivisionCode                         {$record/lei:Region};
                 leio:addressNumber                           {$record/lei:AddressNumber};
                 leio:addressNumberWithinBuilding             {$record/lei:AddressNumberWithinBuilding};
                 leio:mailRouting                             {$record/lei:MailRouting};
                 fibo-fnd-rel-rel:isClassifiedBy              <{$schema}>;
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
                   fibo-fbc-fct-ra:isRegisteredBy                         <{$registrationManaging}>;
                   fibo-fnd-rel-rel:comprises                             <{$glei}>;
    }
};

declare function local:LEI ($uri as xs:string, $record) {
    let $denotation := fn:concat($uri, "/entry")
    let $lei        := fn:concat($uri, "/lei")
    let $le_n       := fn:concat($uri, "/id", "/1")
    construct {
        <{$uri}> a                                          fibo-be-le-lp:LegalEntity;
                 fibo-be-corp-corp:hasLegalFormAbbreviation {$record/lei:Entity/lei:LegalForm/lei:OtherLegalForm[fn:not(fn:matches(., "other|select legal form"))]};
                 fibo-fnd-rel-rel:hasLegalName              {$record/lei:Entity/lei:LegalName};
                 leio:autoAsciiTransliteratedLegalName      {$record/lei:Entity/lei:TransliteratedOtherEntityNames/lei:TransliteratedOtherEntityName[@type='AUTO_ASCII_TRANSLITERATED_LEGAL']};
                 leio:entityCategory                        {$record/lei:Entity/lei:EntityCategory};
                 leio:expirationDate                        {$record/lei:Entity/lei:EntityExpirationDate/text()}^^xsd:dateTime;
                 leio:expirationReason                      {$record/lei:Entity/lei:EntityExpirationReason};
                 leio:legalJurisdictionCode                 {$record/lei:Entity/lei:LegalJurisdiction};
                 leio:nextVersion                           {$record/lei:Entity/lei:NextVersion};
                 leio:status                                {$record/lei:Entity/lei:EntityStatus};
                 fibo-fnd-rel-rel:hasDenotation             <{$denotation}>.
        { local:lei_lei($lei, $record, $uri),
            for $x in $record/lei:Entity/lei:OtherEntityNames/lei:OtherEntityName
                construct {
                    <{$uri}>
                    leio:otherLegalName                        {$x[@type = 'ALTERNATIVE_LANGUAGE_LEGAL_NAME']};
                    leio:previousLegalName                     {$x[@type = 'PREVIOUS_LEGAL_NAME']};
                    leio:tradingName                           {$x[@type = 'TRADING_OR_OPERATING_NAME']};
                },
            for $x in $record/lei:Entity/lei:TransliteratedOtherEntityNames/lei:TransliteratedOtherEntityName
                construct {
                    <{$uri}>
                    leio:preferredAsciiTransliteratedLegalName {$x[@type = 'PREFERRED_ASCII_TRANSLITERATED_LEGAL_NAME']};
                    leio:autoAsciiTransliteratedLegalName      {$x[@type = 'AUTO_ASCII_TRANSLITERATED_LEGAL_NAME']};
                }
        }
    }
};

declare function local:glei_master() {
    let $url := ""
    construct {
        glei: a fibo-fbc-fct-breg:BusinessRegistry;
              fibo-fnd-rel-rel:hasName "Global GLEI register";
    }
};

declare function local:IdentifiedByAuthority($uri as xs:string, $record, $classifier as xs:string, $authID, $authEntityID){
    let $glei := "http://data.ontotext.com/resource/glei/"
    let $suffix := fn:concat($classifier, "/", $authID)
    let $auth := fn:concat($glei, $suffix)
    let $url := fn:concat($glei, "id/", $suffix)
    return
    if (($authID/text() = 'RA888888') or ($authID/text() = 'RA999999') or fn:not(fn:exists($authID))) then ()
    else (let $dagoeba := ""
          construct {
            <{$uri}> fibo-fnd-aap-agt:isIdentifiedBy <{$url}>.
            <{$url}> a fibo-be-corp-corp:RegistrationIdentifier;
                     fibo-fnd-rel-rel:hasUniqueIdentifier {$authEntityID};
                     fibo-fbc-fct-ra:isRegisteredBy <{$auth}>.
            <{$auth}> a fibo-fbc-fct-ra:RegistrationAuthority;
                     dct:identifier {$authID};
                     fibo-fnd-rel-rel:isClassifiedBy <{fn:concat($glei, $classifier)}>.
        })
};

declare function local:status($uri as xs:string, $record){
    let $dummy := ""
    let $node := fn:concat("http://data.ontotext.com/resource/glei/status/", $record/lei:Entity/lei:EntityStatus)
    construct {
        <{$uri}> fibo-fnd-rel-rel:isClassifiedBy <{$node}>.
        <{$node}> a fibo-fnd-rel-rel:Reference;
                  fibo-fnd-rel-rel:hasUniqueIdentifier {$record/lei:Entity/lei:EntityStatus};
                  fibo-fnd-rel-rel:isMemberOf <http://data.ontotext.com/resource/glei/status>.
        <http://data.ontotext.com/resource/glei/status> a fibo-fnd-arr-cls:classificationScheme;
                                                        fibo-fnd-rel-rel:hasName "LEI status".
    }
};


let $dummy := "FD"
return(
for $record in doc($input)/lei:LEIData/lei:LEIRecords/lei:LEIRecord
let $glei := "http://data.ontotext.com/resource/glei/"
let $uri := fn:concat("http://data.ontotext.com/resource/glei/", $record/lei:LEI/text())
let $headquarters    := fn:concat($uri, "/address/headquarters")
let $legal           := fn:concat($uri, "/address/legal")
let $hq_predicate    := fn:concat("http://www.omg.org/spec/EDMC-FIBO/FBC/FunctionalEntities/BusinessRegistries/", "hasHeadquartersAddress")
let $legal_predicate := fn:concat("http://www.omg.org/spec/EDMC-FIBO/FND/Places/Addresses/", "hasAddressOfLegalFormation")
return (
    local:LEI($uri, $record),
    local:entry($uri, $record),
    local:registrationManaging($uri, $record),
    local:address($headquarters, $record/lei:Entity/lei:HeadquartersAddress, $uri, $hq_predicate,    fn:concat($glei, "address/headquarters/preferred")),
    local:address($legal       , $record/lei:Entity/lei:LegalAddress,        $uri, $legal_predicate, fn:concat($glei, "address/legal/preferred")),
    for $legal at $x in $record/lei:Entity/lei:OtherAddresses/lei:OtherAddress[@type="ALTERNATIVE_LANGUAGE_LEGAL_ADDRESS"] return
        local:address(fn:concat($uri, "/address/legal/", $x), $legal, $uri, $legal_predicate,     fn:concat($glei, "address/legal/other")),
    for $hq    at $x in $record/lei:Entity/lei:OtherAddresses/lei:OtherAddress[@type="ALTERNATIVE_LANGUAGE_HEADQUARTERS_ADDRESS"] return
        local:address(fn:concat($uri, "/address/headquarters/", $x), $hq, $uri, $hq_predicate,    fn:concat($glei, "address/headquarters/other")),
    for $legal at $x in $record/lei:Entity/lei:TransliteratedOtherAddresses/lei:TransliteratedOtherAddress[@type="PREFERRED_ASCII_TRANSLITERATED_LEGAL_ADDRESS"] return
        local:address(fn:concat($uri, "/address/legal/transliterated"), $legal, $uri, $legal_predicate,     fn:concat($glei, "address/legal/preferred/transliterated")),
    for $hq    at $x in $record/lei:Entity/lei:TransliteratedOtherAddresses/lei:TransliteratedOtherAddress[@type="PREFERRED_ASCII_TRANSLITERATED_HEADQUARTERS_ADDRESS"] return
        local:address(fn:concat($uri, "/address/headquarters/transliterated"), $hq, $uri, $hq_predicate,    fn:concat($glei, "address/headquarters/preferred/transliterated")),
    for $legal at $x in $record/lei:Entity/lei:TransliteratedOtherAddresses/lei:TransliteratedOtherAddress[@type="AUTO_ASCII_TRANSLITERATED_LEGAL_ADDRESS"] return
        local:address(fn:concat($uri, "/address/legal/transliterated/", $x), $legal, $uri, $legal_predicate,     fn:concat($glei, "address/legal/other/transliterated")),
    for $hq    at $x in $record/lei:Entity/lei:TransliteratedOtherAddresses/lei:TransliteratedOtherAddress[@type="AUTO_ASCII_TRANSLITERATED_HEADQUARTERS_ADDRESS"] return
        local:address(fn:concat($uri, "/address/headquarters/transliterated/", $x), $hq, $uri, $hq_predicate,    fn:concat($glei, "address/headquarters/other/transliterated")),
    local:IdentifiedByAuthority($uri, $record, "register", $record/lei:Entity/lei:RegistrationAuthority/lei:RegistrationAuthorityID,
                                                           $record/lei:Entity/lei:RegistrationAuthority/lei:RegistrationAuthorityEntityID),
    local:IdentifiedByAuthority($uri, $record, "validationauthority", $record/lei:Entity/lei:Registration/lei:ValidationAuthority/lei:ValidationAuthorityID,
                                                                      $record/lei:Entity/lei:Registration/lei:ValidationAuthority/lei:ValidationAuthorityEntityID),
    local:status($uri, $record)
),
local:glei_master()
)

