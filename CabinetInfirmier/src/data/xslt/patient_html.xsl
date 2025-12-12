<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- racine : le patient -->
    <xsl:template match="/patient">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Fiche patient - <xsl:value-of select="prenom"/> <xsl:value-of select="nom"/></title>
                <link rel="stylesheet" href="../css/style.css"/>
            </head>
            <body>
                <h1>
                    <xsl:value-of select="prenom"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="nom"/>
                </h1>

                <p><b>Sexe :</b> <xsl:value-of select="sexe"/></p>
                <p><b>Date de naissance :</b> <xsl:value-of select="naissance"/></p>
                <p><b>Numéro de sécurité sociale :</b> <xsl:value-of select="numeroSS"/></p>

                <h2>Adresse</h2>
                <p>
                    <xsl:if test="adresse/etage">
                        <xsl:text>Étage </xsl:text>
                        <xsl:value-of select="adresse/etage"/>
                        <br/>
                    </xsl:if>
                    <xsl:if test="adresse/numero">
                        <xsl:value-of select="adresse/numero"/>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="adresse/rue"/>,
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="adresse/codePostal"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="adresse/ville"/>
                </p>

                <h2>Visites</h2>
                <ul>
                    <!-- on délègue l’affichage des visites -->
                    <xsl:apply-templates select="visite"/>
                </ul>
            </body>
        </html>
    </xsl:template>

    <!-- une visite -->
    <xsl:template match="visite">
        <li>
            <b><xsl:value-of select="@date"/></b><br/>
            Infirmier :
            <xsl:value-of select="intervenant/prenom"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="intervenant/nom"/>
            <br/>
            Acte :
            <xsl:value-of select="acte"/>
        </li>
    </xsl:template>

</xsl:stylesheet>
