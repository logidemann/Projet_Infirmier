// See https://aka.ms/new-console-template for more information

using CabinetInfirmier;
using Fragmentum.Data.Tools;

// --- CONFIGURATION DES CHEMINS ---
string xmlFile = "./src/data/xml/cabinet.xml";
string xsdFile = "./src/data/xsd/cabinet.xsd";
string xsltFile = "./src/data/xslt/infirmier.xsl"; 
string htmlOutput = "./src/data/html/resultat.html";

// Vérification de l'existence du fichier XML pour éviter un crash immédiat
if (!File.Exists(xmlFile))
{
    Console.WriteLine($"ERREUR : Le fichier {xmlFile} est introuvable.");
    return;
}

Console.WriteLine("=== DÉBUT DES TESTS DU PROJET CABINET INFIRMIER ===\n");

// TEST 1 : VALIDATION XML vs XSD
Console.WriteLine("--- 1. Test de Validation XSD ---");
if (File.Exists(xsdFile))
{
    string namespaceUrl = "http://www.univ-grenoble-alpes.fr/l3miage/medical";
            
    await XMLUtils.ValidateXmlFileAsync(namespaceUrl, xsdFile, xmlFile);
}
else
{
    Console.WriteLine($"Fichier XSD introuvable : {xsdFile}");
}
Console.WriteLine();

// TEST 2 : TRANSFORMATION XSLT
Console.WriteLine("--- 2. Test de Transformation XSLT ---");
if (File.Exists(xsltFile))
{
    // Création du dossier de sortie si inexistant
    Directory.CreateDirectory(Path.GetDirectoryName(htmlOutput));
    XMLUtils.XslTransform(xmlFile, xsltFile, htmlOutput);
    Console.WriteLine($"Vérifiez le fichier généré ici : {Path.GetFullPath(htmlOutput)}");
}
else
{
    Console.WriteLine($"Fichier XSLT introuvable ({xsltFile}), étape sautée.");
}
Console.WriteLine();

// TEST 3 : ANALYSE VIA XMLREADER
        
Console.WriteLine("--- 3. Test de l'analyse XmlReader (Cabinet) ---");
CabinetXSLT cabinet = new CabinetXSLT();

cabinet.AnalyseGlobale(xmlFile);
        
// Compte les actes
int nombreActes = cabinet.CompterActes(xmlFile);
Console.WriteLine($"Nombre total d'actes trouvés dans le fichier : {nombreActes}");
Console.WriteLine();

// TEST 4 : MODIFICATION VIA DOM (Section 7.3.3)

Console.WriteLine("--- 4. Test de modification DOM (Ajout Infirmier) ---");
        
// On ajoute l'infirmier : Jean Némard
// Cette méthode modifie directement le fichier cabinet.xml dans le dossier de sortie (bin/Debug/...)
try 
{
    cabinet.AjouterInfirmier(xmlFile, "Némard", "Jean");
    Console.WriteLine("Vérification : Ouvrez le fichier cabinet.xml pour voir le nouvel infirmier (id 005).");
            
    // Petite vérification immédiate en relisant le fichier pour voir si "Némard" apparait
    string content = File.ReadAllText(xmlFile);
    if (content.Contains("Némard"))
    {
        Console.WriteLine("SUCCÈS : L'infirmier 'Némard' a bien été trouvé dans le fichier après modification.");
    }
    else
    {
        Console.WriteLine("ECHEC : L'infirmier n'a pas été trouvé après la tentative d'ajout.");
    }
}
catch (Exception ex)
{
    Console.WriteLine($"Erreur lors de la modification DOM : {ex.Message}");
} 

// TEST 5 SERIALIZATION ET DESERIALISATION

try
{
    // 1. DÉSÉRIALISATION
    string xmlOutput = "../../../src/data/xml/cabinet_modif.xml";
    Console.WriteLine("Lecture du fichier XML...");
    XmlManager<Cabinet> xmlManager = new XmlManager<Cabinet>();
    Cabinet cabinetXML = xmlManager.Load(xmlFile);
    
    if (cabinetXML != null)
    {
        Console.WriteLine($"Cabinet chargé : {cabinetXML.Nom}");
        Console.WriteLine($"Nombre de patients actuels : {cabinetXML.Patients.ListePatients.Count}");

        // AJOUT D'UN NOUVEAU PATIENT
        Console.WriteLine("Ajout du patient 'Mme Niskotch Nicole'...");

        Patient nouveauPatient = new Patient
        {
            Nom = "Niskotch",
            Prenom = "Nicole",
            Sexe = "F",
            Naissance = "1980-05-12",
            NumeroSS = "280059912345678", // Exemple random
            Adresse = new Adresse
            {
                Numero = 12,
                Rue = "Rue des Lilas",
                CodePostal = "38000",
                Ville = "Grenoble"
            },

        };
        
        Visite visite = new Visite
        {
            Date = "2023-12-15", 
            IntervenantId = "001" // On l'assigne à l'infirmier 001 déjà existant
        };

        // On ajoute un acte à la visite 
        visite.Actes.Add(new Acte { Id = "101" });

        // On attache la visite au patient
        nouveauPatient.Visite.Add(visite);

        // On ajoute à la liste
        cabinetXML.Patients.ListePatients.Add(nouveauPatient);
                
        // on prend le premier patient de la liste pour l'exemple
        if (cabinetXML.Patients.ListePatients.Count > 0)
        {
            Patient p = cabinetXML.Patients.ListePatients[0];
            Console.WriteLine($"Ajout d'une visite pour {p.Prenom} {p.Nom}...");

            Visite nouvelleVisite = new Visite
            {
                Date = "2025-12-25",
                IntervenantId = "001" // ID d'une infirmière existante
            };
                    
            // Ajout d'un acte à la visite
            nouvelleVisite.Actes.Add(new Acte { Id = "101" });

            p.Visite.Add(nouvelleVisite);
        }
                
        Console.WriteLine($"Sauvegarde vers {xmlOutput}...");
        // 2 SERIALISATION
        xmlManager.Save(xmlOutput, cabinetXML);
                
        Console.WriteLine("Terminé ! Vérifiez le fichier de sortie.");
    }
}
catch (Exception ex)
{
    Console.WriteLine($"Une erreur est survenue : {ex.Message}");
    if (ex.InnerException != null) Console.WriteLine($"Détail : {ex.InnerException.Message}");
}

Console.WriteLine("\n=== FIN DES TESTS ==="); Console.ReadLine(); // Pause pour lire la console