<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cab="http://www.univ-grenoble-alpes.fr/l3miage/medical">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="cab:patient">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Patient <xsl:value-of select="cab:prenom"/></title>
                <link rel="stylesheet" href="../css/style.css"/>
            </head>
            <body>
                <h1>Fiche Patient</h1>
                <p><b>Nom :</b> <xsl:value-of select="cab:nom"/></p>
                <p><b>Prénom :</b> <xsl:value-of select="cab:prenom"/></p>
                <p><b>Sexe :</b> <xsl:value-of select="cab:sexe"/></p>
                <p><b>Date de naissance :</b> <xsl:value-of select="cab:naissance"/></p>
                <p><b>Numéro :</b> <xsl:value-of select="cab:numero"/></p>
                <h3>Adresse</h3>
                <p>
                    <xsl:value-of select="cab:adresse/cab:rue"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="cab:adresse/cab:codePostal"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="cab:adresse/cab:ville"/>
                </p>
                <h3>Dernière visite</h3>
                <p>
                    Date : <xsl:value-of select="cab:visite/@date"/>
                    <br/>
                    Infirmier(e) : <xsl:value-of select="cab:visite/@intervenant"/>
                </p>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
