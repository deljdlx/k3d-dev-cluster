<?php
phpinfo();

// Exemple de code mal écrit avec plusieurs problèmes

// 1️⃣ Mauvaise pratique : Variable non initialisée
echo $nom;

// 2️⃣ Problème de type : Addition entre string et int
$age = "30";
$total = $age + 5;

// 3️⃣ SQL Injection 🚨 (pas de requête préparée)
$conn = new mysqli("localhost", "root", "password", "test_db");
$user_input = $_GET['id'];
$sql = "SELECT * FROM users WHERE id = " . $user_input;
$result = $conn->query($sql);

// 4️⃣ Problème : Fonction qui manque un return explicite
function somme($a, $b) {
    $result = $a + $b; // Manque un "return"
}

// 5️⃣ Fonction inutilement complexe (code smell)
function calcul($x, $y) {
    if ($x > 0) {
        if ($y > 0) {
            return $x * $y;
        } else {
            return $x + $y;
        }
    } else {
        if ($y > 0) {
            return $x - $y;
        } else {
            return $x / ($y + 1); // Division potentielle par zéro
        }
    }
}


echo $yolo;




// 6️⃣ Problème de visibilité (classe mal encapsulée)
class Utilisateur {
    public $nom;
    public $email;

    function __construct($nom, $email) {
        $this->nom = $nom;
        $this->email = $email;
    }
}

$utilisateur = new Utilisateur("Alice", "alice@example.com");

// 7️⃣ Faille XSS 🚨
echo "<div>Bonjour, " . $_GET['name'] . "</div>"; // Pas d’échappement

