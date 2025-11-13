<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.univ-grenoble-alpes.fr/l3miage/medical"
                exclude-result-prefixes="m">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- Nom du patient à extraire -->
    <xsl:param name="destinedName">Alécole</xsl:param>

    <!-- actes depuis actes.xml (sans namespace) -->
    <xsl:variable name="actes"
                  select="document('../xml/actes.xml')/actes/acte"/>

    <!-- point d'entrée -->
    <xsl:template match="/">
        <!-- on récupère le patient par son nom -->
        <xsl:variable name="p"
                      select="/m:cabinet/m:patients/m:patient[m:nom=$destinedName]"/>

        <patient>
            <nom><xsl:value-of select="$p/m:nom"/></nom>
            <prenom><xsl:value-of select="$p/m:prenom"/></prenom>
            <sexe><xsl:value-of select="$p/m:sexe"/></sexe>
            <naissance><xsl:value-of select="$p/m:naissance"/></naissance>
            <numeroSS><xsl:value-of select="$p/m:numero"/></numeroSS>

            <!-- adresse -->
            <xsl:apply-templates select="$p/m:adresse" mode="adresse"/>

            <!-- visites triées par date -->
            <xsl:apply-templates select="$p/m:visite"
                                 mode="visite">
                <xsl:sort select="@date"/>
            </xsl:apply-templates>
        </patient>
    </xsl:template>

    <!-- construction du bloc <adresse> -->
    <xsl:template match="m:adresse" mode="adresse">
        <adresse>
            <xsl:if test="m:etage">
                <etage><xsl:value-of select="m:etage"/></etage>
            </xsl:if>
            <xsl:if test="m:numero">
                <numero><xsl:value-of select="m:numero"/></numero>
            </xsl:if>
            <rue><xsl:value-of select="m:rue"/></rue>
            <codePostal><xsl:value-of select="m:codePostal"/></codePostal>
            <ville><xsl:value-of select="m:ville"/></ville>
        </adresse>
    </xsl:template>

    <!-- construction de chaque <visite> -->
    <xsl:template match="m:visite" mode="visite">
        <!-- code de l'acte -->
        <xsl:variable name="code" select="m:acte/@id"/>
        <!-- libellé correspondant dans actes.xml -->
        <xsl:variable name="acte" select="$actes[@code=$code]"/>
        <!-- infirmier correspondant -->
        <xsl:variable name="inf"
                      select="/m:cabinet/m:infirmiers/m:infirmier[@id=@intervenant]"/>

        <visite date="{@date}">
            <intervenant>
                <nom><xsl:value-of select="$inf/m:nom"/></nom>
                <prenom><xsl:value-of select="$inf/m:prenom"/></prenom>
            </intervenant>
            <acte><xsl:value-of select="$acte/libelle"/></acte>
        </visite>
    </xsl:template>

</xsl:stylesheet>
