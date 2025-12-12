namespace CabinetInfirmier;

using System;
using System.Xml;
using System.Collections.Generic;

public class CabinetXSLT
{
    // Récupération d'informations avec XmlReader 
    public void AnalyseGlobale(string filepath)
    {
        using (XmlReader reader = XmlReader.Create(filepath))
        {
            reader.MoveToContent();

            while (reader.Read())
            {
                switch (reader.NodeType) // Switch sur le type de noeud 
                {
                    case XmlNodeType.Element:
                        Console.WriteLine($"Début élément: {reader.Name}, Attributs: {reader.AttributeCount}");
                        if (reader.HasAttributes)
                        {
                            while (reader.MoveToNextAttribute())
                            {
                                Console.WriteLine($" -> Attribut: {reader.Name} = {reader.Value}");
                            }
                            reader.MoveToElement(); // Retour à l'élément
                        }
                        break;
                    
                    case XmlNodeType.Text:
                        Console.WriteLine($"Texte: {reader.Value.Trim()}");
                        break;

                    case XmlNodeType.EndElement:
                        Console.WriteLine($"Fin élément: {reader.Name}"); 
                        break;
                }
            }
        }
    }

    // Fonction pour compter les actes
    public int CompterActes(string filepath)
    {
        int count = 0;
        using (XmlReader reader = XmlReader.Create(filepath))
        {
            while (reader.Read())
            {
                if (reader.NodeType == XmlNodeType.Element && reader.Name == "acte")
                {
                    count++;
                }
            }
        }
        return count;
    }

    // Modification DOM - Ajout d'un infirmier
    public void AjouterInfirmier(string xmlPath, string nom, string prenom)
    {
        XmlDocument doc = new XmlDocument();
        
        if (File.Exists(xmlPath))
        {
            using (FileStream fs = new FileStream(xmlPath, FileMode.Open, FileAccess.Read))
            {
                doc.Load(fs);
            }
        }
        else
        {
            Console.WriteLine("Fichier introuvable pour modification.");
            return;
        }
    
        XmlNamespaceManager nsmgr = new XmlNamespaceManager(doc.NameTable);
        string ns = "http://www.univ-grenoble-alpes.fr/l3miage/medical"; 
        nsmgr.AddNamespace("cab", ns);

        // Création du nouvel infirmier
        XmlElement newInfirmier = doc.CreateElement("infirmier", ns);
    
        // Calcul ID (Idéalement, il faudrait calculer le max des ID existants + 1, mais 005 suffit pour le TP)
        newInfirmier.SetAttribute("id", "005"); 

        XmlElement elNom = doc.CreateElement("nom", ns);
        elNom.InnerText = nom;
        XmlElement elPrenom = doc.CreateElement("prenom", ns);
        elPrenom.InnerText = prenom;
        XmlElement elPhoto = doc.CreateElement("photo", ns);
        elPhoto.InnerText = $"{prenom}.png";

        newInfirmier.AppendChild(elNom);
        newInfirmier.AppendChild(elPrenom);
        newInfirmier.AppendChild(elPhoto);

        // Ajout au noeud "infirmiers"
        XmlNode infirmiersNode = doc.SelectSingleNode("//cab:infirmiers", nsmgr);
        if (infirmiersNode != null)
        {
            infirmiersNode.AppendChild(newInfirmier);
            
            doc.Save(xmlPath); 
            Console.WriteLine("Infirmier ajouté.");
        }
        else
        {
            Console.WriteLine("Erreur : Le nœud <infirmiers> n'a pas été trouvé (problème de namespace ?).");
        }
    }
}