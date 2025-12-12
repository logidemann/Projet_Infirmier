<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.univ-grenoble-alpes.fr/l3miage/medical"
                exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- infirmière courante -->
    <xsl:param name="destinedId">001</xsl:param>

    <!-- actes.xml (sans namespace) -->
    <xsl:variable name="actes"
                  select="document('../xml/actes.xml')/actes/acte"/>

    <!-- point d’entrée -->
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="utf-8"/>
                <title>Planning infirmière</title>
                <link rel="stylesheet" href="../css/style.css"/>
                <script type="text/javascript" src="../js/buttonScript.js">//</script>
            </head>
            <body>

                <!-- infirmière -->
                <xsl:variable name="inf"
                              select="/m:cabinet/m:infirmiers/m:infirmier[@id=$destinedId]"/>

                <h1>
                    Bonjour
                    <xsl:value-of select="$inf/m:prenom"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$inf/m:nom"/> !
                </h1>

                <!-- patients de cette infirmière -->
                <xsl:variable name="patients"
                              select="/m:cabinet/m:patients/m:patient[m:visite/@intervenant=$destinedId]"/>

                <p>
                    Aujourd’hui, vous avez
                    <b><xsl:value-of select="count($patients)"/></b>
                    patient(s).
                </p>

                <!-- on délègue le traitement des patients -->
                <xsl:apply-templates select="$patients" mode="patient"/>

            </body>
        </html>
    </xsl:template>

    <!-- affichage d’un patient -->
    <xsl:template match="m:patient" mode="patient">
        <div class="patient">
            <h2>
                <xsl:value-of select="m:nom"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="m:prenom"/>
            </h2>

            <!-- adresse -->
            <p>
                <xsl:if test="m:adresse/m:numero">
                    <xsl:value-of select="m:adresse/m:numero"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="m:adresse/m:rue"/>,
                <xsl:text> </xsl:text>
                <xsl:value-of select="m:adresse/m:codePostal"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="m:adresse/m:ville"/>
            </p>

            <!-- visites pour cette infirmière -->
            <xsl:apply-templates select="m:visite[@intervenant=$destinedId]"
                                 mode="visite"/>

            <!-- bouton facture -->
            <button>
                <xsl:attribute name="onclick">
                    <xsl:text>openFacture('</xsl:text>
                    <xsl:value-of select="m:prenom"/>
                    <xsl:text>','</xsl:text>
                    <xsl:value-of select="m:nom"/>
                    <xsl:text>','</xsl:text>
                    <!-- ici on passe le/les codes actes -->
                    <xsl:value-of select="m:visite[@intervenant=$destinedId]/m:acte/@id"/>
                    <xsl:text>')</xsl:text>
                </xsl:attribute>
                Facture
            </button>
        </div>
    </xsl:template>

    <!-- affichage d’une visite -->
    <xsl:template match="m:visite" mode="visite">
        <p>
            Visite le
            <b><xsl:value-of select="@date"/></b><br/>
            <xsl:text>Soins : </xsl:text>
            <xsl:apply-templates select="m:acte" mode="acte"/>
        </p>
    </xsl:template>

    <!-- affichage d’un acte (libellé depuis actes.xml) -->
    <xsl:template match="m:acte" mode="acte">
        <xsl:variable name="code" select="@id"/>
        <xsl:variable name="acte" select="$actes[@code=$code]"/>
        <xsl:value-of select="$acte/libelle"/>
    </xsl:template>

</xsl:stylesheet>
