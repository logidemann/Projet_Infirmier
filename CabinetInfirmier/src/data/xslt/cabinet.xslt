<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cab="http://www.univ-grenoble-alpes.fr/l3miage/medical">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Cabinet Infirmier</title>
                <link rel="stylesheet" type="text/css" href="../css/style.css"/>
            </head>
            <body>
                <h1><xsl:value-of select="cab:cabinet/cab:nom"/></h1>

                <h2>Adresse</h2>
                <p>
                    <xsl:value-of select="cab:cabinet/cab:adresse/cab:numero"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="cab:cabinet/cab:adresse/cab:rue"/>,
                    <xsl:value-of select="cab:cabinet/cab:adresse/cab:codePostal"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="cab:cabinet/cab:adresse/cab:ville"/>
                </p>

                <h2>Liste des infirmiers</h2>
                <ul>
                    <xsl:for-each select="cab:cabinet/cab:infirmiers/cab:infirmier">
                        <li>
                            <xsl:value-of select="cab:prenom"/> <xsl:text> </xsl:text>
                            <xsl:value-of select="cab:nom"/>
                            (<xsl:value-of select="@id"/>)
                        </li>
                    </xsl:for-each>
                </ul>

                <h2>Liste des patients</h2>
                <ul>
                    <xsl:for-each select="cab:cabinet/cab:patients/cab:patient">
                        <li>
                            <xsl:value-of select="cab:prenom"/> <xsl:text> </xsl:text>
                            <xsl:value-of select="cab:nom"/>
                        </li>
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
