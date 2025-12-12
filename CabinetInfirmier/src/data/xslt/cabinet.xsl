<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cab="http://www.univ-grenoble-alpes.fr/l3miage/medical">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- point d'entrée : le document -->
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Cabinet Infirmier</title>
                <link rel="stylesheet" type="text/css" href="../css/style.css"/>
            </head>
            <body>
                <!-- on applique sur l’élément racine cab:cabinet -->
                <xsl:apply-templates select="cab:cabinet"/>
            </body>
        </html>
    </xsl:template>

    <!-- template pour <cabinet> -->
    <xsl:template match="cab:cabinet">
        <h1><xsl:value-of select="cab:nom"/></h1>

        <h2>Adresse</h2>
        <p>
            <xsl:value-of select="cab:adresse/cab:numero"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="cab:adresse/cab:rue"/>,
            <xsl:value-of select="cab:adresse/cab:codePostal"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="cab:adresse/cab:ville"/>
        </p>

        <h2>Liste des infirmiers</h2>
        <ul>
            <!-- on délègue l’affichage des infirmiers -->
            <xsl:apply-templates select="cab:infirmiers/cab:infirmier"/>
        </ul>

        <h2>Liste des patients</h2>
        <ul>
            <!-- on délègue l’affichage des patients -->
            <xsl:apply-templates select="cab:patients/cab:patient"/>
        </ul>
    </xsl:template>

    <!-- un infirmier -->
    <xsl:template match="cab:infirmier">
        <li>
            <xsl:value-of select="cab:prenom"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="cab:nom"/>
            (<xsl:value-of select="@id"/>)
        </li>
    </xsl:template>

    <!-- un patient -->
    <xsl:template match="cab:patient">
        <li>
            <xsl:value-of select="cab:prenom"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="cab:nom"/>
        </li>
    </xsl:template>

</xsl:stylesheet>
