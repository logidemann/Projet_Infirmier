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

            <adresse>
                <xsl:if test="$p/m:adresse/m:etage">
                    <etage><xsl:value-of select="$p/m:adresse/m:etage"/></etage>
                </xsl:if>
                <xsl:if test="$p/m:adresse/m:numero">
                    <numero><xsl:value-of select="$p/m:adresse/m:numero"/></numero>
                </xsl:if>
                <rue><xsl:value-of select="$p/m:adresse/m:rue"/></rue>
                <codePostal><xsl:value-of select="$p/m:adresse/m:codePostal"/></codePostal>
                <ville><xsl:value-of select="$p/m:adresse/m:ville"/></ville>
            </adresse>

            <!-- visites triées par date -->
            <xsl:for-each select="$p/m:visite">
                <xsl:sort select="@date"/>

                <!-- code de l'acte -->
                <xsl:variable name="code" select="m:acte/@id"/>
                <!-- libellé correspondant dans actes.xml -->
                <xsl:variable name="acte" select="$actes[@code=$code]"/>

                <!-- infirmier correspondant -->
                <xsl:variable name="inf"
                              select="/m:cabinet/m:infirmiers/m:infirmier[@id=current()/@intervenant]"/>

                <visite date="{@date}">
                    <intervenant>
                        <nom><xsl:value-of select="$inf/m:nom"/></nom>
                        <prenom><xsl:value-of select="$inf/m:prenom"/></prenom>
                    </intervenant>
                    <acte><xsl:value-of select="$acte/libelle"/></acte>
                </visite>
            </xsl:for-each>
        </patient>
    </xsl:template>
</xsl:stylesheet>
