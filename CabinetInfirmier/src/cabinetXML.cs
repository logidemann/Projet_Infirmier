namespace CabinetInfirmier;

using System;
using System.Collections.Generic;
using System.Xml.Serialization;
using System.Text.RegularExpressions;

    // Racine du document XML
    [XmlRoot("cabinet", Namespace = "http://www.univ-grenoble-alpes.fr/l3miage/medical")]
    public class Cabinet
    {
        [XmlElement("nom")]
        public string Nom { get; set; }

        [XmlElement("adresse")]
        public Adresse Adresse { get; set; }

        [XmlElement("infirmiers")]
        public Infirmiers Infirmiers { get; set; }

        [XmlElement("patients")]
        public Patients Patients { get; set; }
    }

    public class Infirmiers
    {
        // Mappe la liste des balises <infirmier>
        [XmlElement("infirmier")]
        public List<Infirmier> ListeInfirmiers { get; set; } = new List<Infirmier>();
    }

    public class Infirmier
    {
        [XmlAttribute("id")]
        public string Id { get; set; }

        [XmlElement("nom")]
        public string Nom { get; set; }

        [XmlElement("prenom")]
        public string Prenom { get; set; }

        [XmlElement("photo")]
        public string Photo { get; set; }
    }

    public class Patients
    {
        [XmlElement("patient")]
        public List<Patient> ListePatients { get; set; } = new List<Patient>();
    }

    public class Patient
    {
        [XmlElement("nom")]
        public string Nom { get; set; }

        [XmlElement("prenom")]
        public string Prenom { get; set; }

        [XmlElement("sexe")]
        public string Sexe { get; set; }

        [XmlElement("naissance")]
        public string Naissance { get; set; }

        [XmlElement("numero")] // NIR
        public string NumeroSS { get; set; } = "0000000000000";

        [XmlElement("adresse")]
        public Adresse Adresse { get; set; }

        [XmlElement("visite")]
        public List<Visite> Visite { get; set; } = new List<Visite>();
    }

    public class Visite
    {
        [XmlAttribute("date")]
        public string Date { get; set; } // Format YYYY-MM-DD

        [XmlAttribute("intervenant")]
        public string IntervenantId { get; set; }

        [XmlElement("acte")]
        public List<Acte> Actes { get; set; } = new List<Acte>();
    }

    public class Acte
    {
        [XmlAttribute("id")]
        public string Id { get; set; }
    }
    public class Adresse
    {
        private int? _numero;
        private string _codePostal;

        [XmlElement("etage")]
        public string Etage { get; set; }

        [XmlElement("numero")]
        public int? Numero 
        { 
            get { return _numero; }
            set 
            {
                if (value.HasValue && value <= 0) throw new ArgumentException("Positif requit");
                _numero = value;
            }
        }
        
        // Le sérializer cherche automatique ce genre de nom de fonction pour savoir s'il doit sérialiser ou non
        // Syntaxe : ShouldSerialize + Nom XML attribut
        public bool ShouldSerializeNumero()
        {
            return Numero.HasValue;
        }

        [XmlElement("rue")]
        public string Rue { get; set; }

        [XmlElement("codePostal")]
        public string CodePostal 
        { 
            get { return _codePostal; }
            set
            {
                if (!Regex.IsMatch(value, @"^\d{5}$"))
                    throw new ArgumentException("Le code postal doit contenir 5 chiffres.");
                _codePostal = value;
            }
        }

        [XmlElement("ville")]
        public string Ville { get; set; }
    }