class Iterator{
    private var current = 0
    def get_next() : String  = { 
        current += 1
        return current.toString() 
    }
}

new ModelWithMappings {
    val `lei`  = Namespace("http://www.leiroc.org/data/schema/leidata/2014")
    val `clei` = Namespace("http://ns.c-lei.org/leidata/1")
    val `xsi`  = Namespace("http://www.w3.org/2001/XMLSchema-instance")


    val `leio`              = Namespace("http://data.ontotext.com/resource/leio/")
    val `glei`              = Namespace("http://data.ontotext.com/resource/glei/")
    val `dbo`               = Namespace("http://dbpedia.org/ontology/")
    val `dbr`               = Namespace("http://dbpedia.org/resource/")
    val `fibo-be-corp-corp` = Namespace("http://www.omg.org/spec/EDMC-FIBO/BE/Corporations/Corporations/")
    val `fibo-be-le-fbo`    = Namespace("http://www.omg.org/spec/EDMC-FIBO/BE/LegalEntities/FormalBusinessOrganizations/")
    val `fibo-be-le-lei`    = Namespace("http://www.omg.org/spec/EDMC-FIBO/BE/LegalEntities/LEIEntities/")
    val `fibo-be-le-lp`     = Namespace("http://www.omg.org/spec/EDMC-FIBO/BE/LegalEntities/LegalPersons/")
    val `fibo-fbc-fct-breg` = Namespace("http://www.omg.org/spec/EDMC-FIBO/FBC/FunctionalEntities/BusinessRegistries/")
    val `fibo-fbc-fct-ra`   = Namespace("http://www.omg.org/spec/EDMC-FIBO/FBC/FunctionalEntities/RegistrationAuthorities/")
    val `fibo-fnd-aap-agt`  = Namespace("http://www.omg.org/spec/EDMC-FIBO/FND/AgentsAndPeople/Agents/")
    val `fibo-fnd-arr-cls`  = Namespace("http://www.omg.org/spec/EDMC-FIBO/FND/Arrangements/ClassificationSchemes/")
    val `fibo-fnd-arr-id`   = Namespace("http://www.omg.org/spec/EDMC-FIBO/FND/Arrangements/IdentifiersAndIndices/")
    val `fibo-fnd-dt-fd`    = Namespace("http://www.omg.org/spec/EDMC-FIBO/FND/DatesAndTimes/FinancialDates/")
    val `fibo-fnd-plc-adr`  = Namespace("http://www.omg.org/spec/EDMC-FIBO/FND/Places/Addresses/")
    val `fibo-fnd-rel-rel`  = Namespace("http://www.omg.org/spec/EDMC-FIBO/FND/Relations/Relations/")
    val `fibo-fnd-law-jur`  = Namespace("http://www.omg.org/spec/EDMC-FIBO/FND/Law/Jurisdiction/")
    val `lcc-3166-1`        = Namespace("http://www.omg.org/spec/LCC/Countries/ISO3166-1-CountryCodes/")
    val `lcc-3166-2`        = Namespace("http://www.omg.org/spec/LCC/Countries/ISO3166-2-SubdivisionCodes/")
    val `lcc-639-1`         = Namespace("http://www.omg.org/spec/LCC/Languages/ISO639-1-LanguageCodes/")
    val `lcc-639-2`         = Namespace("http://www.omg.org/spec/LCC/Languages/ISO639-2-LanguageCodes/")
    val `lcc-cr`            = Namespace("http://www.omg.org/spec/LCC/Countries/CountryRepresentation/")
    val `lcc-lr`            = Namespace("http://www.omg.org/spec/LCC/Languages/LanguageRepresentation/")
    val `puml`              = Namespace("http://plantuml.com/ontology#")
    val `skos`              = Namespace("http://www.w3.org/2004/02/skos/core#")
    val `vann`              = Namespace("http://purl.org/vocab/vann/")
    val `void`              = Namespace("http://rdfs.org/ns/void#")
    val it1 = new Iterator()
    val it2 = new Iterator()
    val it3 = new Iterator()

    def timestamp_to_dateTime(str: TextGenerator) = {
        transform(str){
            string => string.substring(0,10)
        }{ string => string }
    }

  def langStringMap_local(node : Request, rdf : NodeRequest) = {
    forall(node)(
      when(current.att(lang).exists)(
        rdf > (content @@ current.att(lang))
      ).otherwise(
        rdf > (content)
      )
    )
  }

    def node_if_exists(property : NodeRequest, base : String, cont : Request, handl : Request) = {
        when(content(cont).exists) (
            property > node(base +: frag("CHECKME"))(handle(handl))
        )
    }

    def incremental_node(property : NodeRequest, base : TextGenerator, cont : Request, handler :() => Unit, params : Request*) = {
        val it = new Iterator()
        when(content(cont).exists) (
            forall(cont)(
                property > node(base :+ content(cont) :+ it.get_next())()
            )
        )
        
    }

    def print_glei() = {
        ( a                          > `fibo-fbc-fct-breg`.BusinessRegistry ) ++
        ( `fibo-fnd-rel-rel`.hasName > "Global GLEI register")
    }

    def address_handle(tag : Request, type1 : NodeRequest) = {
        forall(tag)(
            ( a  >  type1 ) ,
            langStringMap_local( lei.Line1 ,`fibo-fbc-fct-breg`.hasAddressLine1  ) ,
            langStringMap_local( lei.Line2 ,`fibo-fbc-fct-breg`.hasAddressLine2  ) ,
            langStringMap_local( lei.Line3 ,`fibo-fbc-fct-breg`.hasAddressLine3  ) ,
            langStringMap_local( lei.Line4 ,`fibo-fbc-fct-breg`.hasAddressLine4  ) ,
            langStringMap_local( lei.City  ,`fibo-fbc-fct-breg`.hasCity          ) ,
            ( `fibo-fbc-fct-breg`.hasPostalCode   > content(lei.PostalCode) ) ,
            ( leio.countryCode                    > content(lei.Country)  ) ,
            ( leio.subdivisionCode                > content(lei.Region)  ) 
        )
    }
    
    def address_handle(tag : Request, type1 : NodeRequest, attr : String, value : String) = {
        forall(tag)( when(att(attr)===value)(
            ( a  >  type1) ,
            langStringMap_local( lei.Line1 ,`fibo-fbc-fct-breg`.hasAddressLine1  ) ,
            langStringMap_local( lei.Line2 ,`fibo-fbc-fct-breg`.hasAddressLine2  ) ,
            langStringMap_local( lei.Line3 ,`fibo-fbc-fct-breg`.hasAddressLine3  ) ,
            langStringMap_local( lei.Line4 ,`fibo-fbc-fct-breg`.hasAddressLine4  ) ,
            langStringMap_local( lei.City  ,`fibo-fbc-fct-breg`.hasCity          ) ,
            ( `fibo-fbc-fct-breg`.hasPostalCode   > content(lei.PostalCode) ) ,
            ( leio.countryCode                    > content(lei.Country)  ) ,
            ( leio.subdivisionCode                > content(lei.Region)  ) 
        ))
    } 
    `lei`.LEIData --> (
        handle( `lei`.LEIRecords )
    )

    `lei`.LEIRecords --> (
        forall(`lei`.LEIRecord)(
            set("lei", "http://data.ontotext.com/resource/glei/" +: content(`lei`.LEI))(
                node(get("lei"))(
                    ( a                                          > `fibo-be-le-lp`.LegalEntity ),
                    // ( `fibo-fnd-rel-rel`.hasLegalName            > content(lei.Entity\lei.LegalName) ),
                    langStringMap_local(lei.Entity\lei.LegalName, `fibo-fnd-rel-rel`.hasLegalName),
                    ( `leio`.expirationReason                      > content(`lei`.Entity\lei.EntityExpirationReason)),
                    ( `leio`.legalJurisdictionCode                 > content(`lei`.Entity\lei.LegalJurisdiction)),
                    ( `leio`.status                                > content(`lei`.Entity\lei.EntityStatus)),
                    handle(`lei`.Entity\`lei`.LegalForm),
                    handle(`lei`.Entity\`lei`.OtherEntityNames),
                    handle(`lei`.Entity\`lei`.EntityExpirationDate),

                    ( `fibo-fnd-rel-rel`.hasDenotatoin             > node(get("lei") :+ "/entry")                                                  (        handle(`lei`.Registration)) ),
                    ( `fibo-fnd-aap-agt`.isIdentifiedBy            > node(get("lei") :+ "/lei")                                                    (        handle(`lei`.LEI)) ),
                    node_if_exists(`fibo-fnd-aap-agt`.isIdentifiedBy, "http://data.ontotext.com/resource/glei/id/", 
                                                                      `lei`.Entity\`lei`.BusinessRegisterEntityID, 
                                                                      `lei`.Entity\`lei`.BusinessRegisterEntityID),
                    ( `fibo-be-le-lei`.hasAddressOfLegalFormation  > node(get("lei") :+ "/address/legal")                                          (address_handle(`lei`.Entity\`lei`.LegalAddress ,       `fibo-fnd-plc-adr`.RegisteredAddress)) ),
                    ( `fibo-fbc-fct-breg`.hasHeadquartersAddress   > node(get("lei") :+ "/address/headquarters")                                   (address_handle(`lei`.Entity\`lei`.HeadquartersAddress, `fibo-fbc-fct-breg`.RegistrationAddress)) ),

                    ( `fibo-be-le-lei`.hasAddressOfLegalFormation  > 
                        when(content(`lei`.Entity\`lei`.OtherAdresses).exists)(
                            node(get("lei") :+ "/address/legal/" :+ it2.get_next() )(
                                address_handle(`lei`.Entity\`lei`.OtherAdresses,       `fibo-fnd-plc-adr`.RegisteredAddress,    "type", "LEGAL_ADDRESS")) )),
                    ( `fibo-fbc-fct-breg`.hasHeadquartersAddress   > 
                        when(content(`lei`.Entity\`lei`.OtherAdresses).exists)(
                            node(get("lei") :+ "/address/headquarters/" :+ it3.get_next() )(
                                address_handle(`lei`.Entity\`lei`.OtherAdresses      , `fibo-fbc-fct-breg`.RegistrationAddress, "type", "HEADQUARTERS_ADDRESS"))))
                )
            )
        )
    )

    `lei`.LegalForm --> ( when((content!=="n/a") and
                             (content!=="OTHER") and
                             (content!=="Oher") and
                             (content!=="NO APLICA"))
                        ( `fibo-be-corp-corp`.hasLegalFormAbbreviation > content ))

    `lei`.EntityExpirationDate --> ( `leio`.expirationDate > (content ^^ xsd.dateTime ))

    `lei`.OtherEntityNames --> (
        forall(`lei`.OtherEntityName)(
            when(att("type")==="AUTO_ASCII_TRANSLITERATED_LEGAL")(
                ( `leio`.autoAsciiTransliteratedLegalName > content )
            ).or(att("type")==="AUTO_ROMANIZED_LEGAL")(
                ( `leio`.autoRomanizedLegalName > content)
            ).or(att("type")==="OTHER_LEGAL")(
                ( `leio`.otherLegalName > content)
            ).or(att("type")==="PREFERRED_ASCII_TRANSLITERATED_LEGAL")(
                ( `leio`.preferredAsciiTransiteratedLegalName > content))
        )
    )
    `lei`.Registration --> (  
        ( a                                         > `fibo-fbc-fct-breg`.BusinessRegistryEntry ),
        ( `fibo-fbc-fct-breg`.hasRegistrationStatus > content(`lei`.RegistrationStatus) ),
        ( `leio`.validationSources                  > content(`lei`.ValidationSources) ),
        ( `fibo-fnd-rel-rel`.comprises              > uri(get("lei") :+ "/lei") ),
        handle(`lei`.InitialRegistrationDate),
        handle(`lei`.LastUpdateDate),
        handle(`lei`.NextRenewalDate),

        ( `fibo-fbc-fct-ra`.isRegisteredBy          > node("http://data.ontotext.com/resource/glei/" +: content(`lei`.ManagingLOU))(
            ( a > `fibo-fbc-fct-breg`.BusinessRegistrationAuthority ),
            ( `fibo-fnd-rel-rel`.manages            > node("http://data.ontotext.com/resource/glei/")( print_glei() ) ) 
        ))
    )
    `lei`.InitialRegistrationDate --> ( `fibo-be-corp-corp`.hasDateOfRegistration             > (content ^^ xsd.dateTime))
    `lei`.LastUpdateDate          --> ( `fibo-fbc-fct-breg`.hasRegistrationStatusRevisionDate > (content ^^ xsd.dateTime))
    `lei`.NextRenewalDate         --> ( `leio`.nextRenewalDate                                > (content ^^ xsd.dateTime))

    `lei`.LEI --> (
        ( a                                      > `fibo-fbc-fct-ra`.RegistryIdentifier ),
        ( a                                      > `fibo-be-le-lei`.LegalEntityIdentifier ),
        ( `fibo-fnd-rel-rel`.hasUniqueIdentifier > content ),
        ( `fibo-fnd-arr-id`.isIndexTo            > node("http://data.ontotext.com/resource/glei/")() ) )

    `lei`.BusinessRegisterEntityID --> (
        ( a                                      > `fibo-be-corp-corp`.RegistrationIdentifier ),
        ( `fibo-fnd-rel-rel`.hasUniqueIdentifier > content ),
        ( rdfs.comment                           > att("register") )
    )

}
