namespace CabinetInfirmier;

using System;
using System.Xml;
using System.Xml.Schema;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.IO;
using System.Threading.Tasks;

public static class XMLUtils
{
    public static async Task ValidateXmlFileAsync(string schemaNamespace, string xsdFilePath, string xmlFilePath)
    {
        var settings = new XmlReaderSettings();
        settings.XmlResolver = new XmlUrlResolver();
        string absoluteXsdPath = Path.GetFullPath(xsdFilePath);
        settings.Schemas.Add(schemaNamespace, absoluteXsdPath);
        settings.ValidationType = ValidationType.Schema;
        settings.ValidationEventHandler += ValidationCallBack;

        Console.WriteLine($"Validation de {xmlFilePath}...");

        try 
        {
            using (FileStream fs = new FileStream(xmlFilePath, FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                using (var reader = XmlReader.Create(fs, settings))
                {
                    while (await reader.ReadAsync()) { } // On lit tout
                }
            }
            Console.WriteLine("Validation terminée.");
        }
        catch (FileNotFoundException)
        {
            Console.WriteLine("ERREUR : Un fichier (XML ou XSD inclus) est introuvable.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"ERREUR : {ex.Message}");
        }
    }

    private static void ValidationCallBack(object sender, ValidationEventArgs e)
    {
        if (e.Severity == XmlSeverityType.Warning)
        {
            Console.Write("WARNING: ");
            Console.WriteLine(e.Message);
        }
        else if (e.Severity == XmlSeverityType.Error)
        {
            Console.Write("ERROR: ");
            Console.WriteLine(e.Message);
        }
    }
    public static void XslTransform(string xmlFilePath, string xsltFilePath, string htmlFilePath)
    {
        try
        {
            XsltSettings settings = new XsltSettings();
            settings.EnableDocumentFunction = true; 
            settings.EnableScript = true;          

            XmlUrlResolver resolver = new XmlUrlResolver();
            XslCompiledTransform xslt = new XslCompiledTransform();

            // Chargement du XSLT
            xslt.Load(xsltFilePath, settings, resolver);
            
            XPathDocument xpathDoc;
            using (FileStream fs = new FileStream(xmlFilePath, FileMode.Open, FileAccess.Read))
            {
                xpathDoc = new XPathDocument(fs);
            } 
            
            // On écrit le résultat HTML
            using (XmlTextWriter htmlWriter = new XmlTextWriter(htmlFilePath, null))
            {
                xslt.Transform(xpathDoc, null, htmlWriter, resolver);
            }
            
            Console.WriteLine($"Transformation terminée : {htmlFilePath} généré.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Erreur XSLT : {ex.Message}");
            if (ex.InnerException != null)
            {
                Console.WriteLine($"Détail : {ex.InnerException.Message}");
            }
        }
    }
}