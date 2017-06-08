<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:base="http://www.registryagency.bg/schemas/envelopev2"
 xmlns:deed="http://www.registryagency.bg/schemas/deedv2"
 xmlns:xs="http://www.w3.org/2001/XMLSchema">
 <xsl:output 
	method="xml"
	version="1.0"
	encoding="UTF-8"
	omit-xml-declaration="no"
	indent="no"/>

	<!-- LEAVE UNSPECIFIED NODES -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xs:annotation" />
	<xsl:template match="xs:import" />


</xsl:stylesheet>
