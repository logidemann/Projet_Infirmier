<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cab="http://www.univ-grenoble-alpes.fr/l3miage/medical">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="cab:patient">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Facture - <xsl:value-of select="cab:prenom"/></title>
                <link rel="stylesheet" href="../css/style.css"/>
                <script src="../js/buttonScript.js"/>
            </head>
            <body>
                <h1>Facture de visite</h1>
                <p><b>Patient :</b> <xsl:value-of select="cab:prenom"/> <xsl:value-of select="cab:nom"/></p>
                <p><b>Date :</b> <xsl:value-of select="cab:visite/@date"/></p>
                <p><b>Infirmier :</b> <xsl:value-of select="cab:visite/@intervenant"/></p>
                <p><b>Acte :</b> <xsl:value-of select="cab:visite/cab:acte/@id"/></p>

                <button onclick="genererFacture()">Afficher le montant</button>
                <p id="montant"></p>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
