<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.univ-grenoble-alpes.fr/l3miage/medical"
                exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- infirmière courante -->
    <xsl:param name="destinedId">001</xsl:param>

    <!-- on charge le fichier actes.xml (sans namespace) -->
    <xsl:variable name="actes"
                  select="document('../xml/actes.xml')/actes/acte"/>

    <xsl:template match="/">

        <html>
            <head>
                <meta charset="utf-8"/>
                <title>Planning infirmière</title>
                <link rel="stylesheet" href="../css/style.css"/>
                <script type="text/javascript" src="../js/facture.js"></script>
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

                <!-- patients qui ont une visite avec cette infirmière -->
                <xsl:variable name="patients"
                              select="/m:cabinet/m:patients/m:patient[m:visite/@intervenant=$destinedId]"/>

                <p>
                    Aujourd’hui, vous avez
                    <b><xsl:value-of select="count($patients)"/></b>
                    patient(s).
                </p>

                <!-- boucle sur les patients -->
                <xsl:for-each select="$patients">
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

                        <!-- visites de cette infirmière pour ce patient -->
                        <xsl:for-each select="m:visite[@intervenant=$destinedId]">
                            <p>
                                Visite le
                                <b><xsl:value-of select="@date"/></b><br/>

                                <xsl:text>Soins : </xsl:text>

                                <!-- pour chaque acte, on cherche le libellé dans actes.xml -->
                                <xsl:for-each select="m:acte">
                                    <xsl:variable name="code" select="@id"/>
                                    <xsl:variable name="acte"
                                                  select="$actes[@code=$code]"/>

                                    <xsl:value-of select="$acte/libelle"/>

                                    <xsl:if test="position() != last()">, </xsl:if>
                                </xsl:for-each>
                            </p>
                        </xsl:for-each>

                        <!-- bouton facture -->
                        <button>
                            <xsl:attribute name="onclick">
                                <xsl:text>openFacture('</xsl:text>
                                <xsl:value-of select="m:prenom"/>
                                <xsl:text>','</xsl:text>
                                <xsl:value-of select="m:nom"/>
                                <xsl:text>','</xsl:text>
                                <!-- on passe la liste des codes d'actes -->
                                <xsl:for-each select="m:visite[@intervenant=$destinedId]/m:acte">
                                    <xsl:value-of select="@id"/>
                                    <xsl:if test="position()!=last()">, </xsl:if>
                                </xsl:for-each>
                                <xsl:text>')</xsl:text>
                            </xsl:attribute>
                            Facture
                        </button>

                    </div>
                </xsl:for-each>

            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
