function genererFacture() {
    const montant = 25 + Math.floor(Math.random() * 50);
    document.getElementById("montant").innerText = "Montant à régler : " + montant + " €";
}

function openFacture(prenom, nom, actes) {
    var width = 500;
    var height = 300;

    var left = (window.innerWidth - width) / 2;
    var top = (window.innerHeight - height) / 2;

    var factureWindow = window.open('', 'facture', 'menubar=yes,scrollbars=yes,top=' + top + ',left=' + left + ',width=' + width + ',height=' + height);
    factureText = "Facture pour : " + prenom + " " + nom + "<br>Actes : " + actes;
    factureWindow.document.write(factureText);
}
