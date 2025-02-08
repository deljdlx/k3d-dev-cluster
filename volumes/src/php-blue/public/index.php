<html>
<body>

<head>
    <title>PHP Blue</title>
    <style>
        body {
            background-color: lightblue;
            color: white;
            text-align: left;
            font-family: Arial, sans-serif;
            color: #555;
        }

        td, th {
            padding: 2px 4px;
            border: solid 1px #555;
        }
    </style>

</head>


<?php
echo "<h1>BLUE</h1>";
echo '<hr/>';

echo '<h2>Test injected env var by configmap</h2>';
echo 'FOOBAR: ';
echo '<div style="border: solid 2px #F00">';
    echo '<div style="; background-color:#CCC">@'.__FILE__.' : '.__LINE__.'</div>';
    echo '<pre style="background-color: rgba(255,255,255, 0.8); color: #000">';
    print_r($_ENV['FOOBAR']);
    echo '</pre>';
echo '</div>';

echo '<hr/>';

echo '<h2>ENV vars:</h2>';
echo '<div style="border: solid 2px #F00">';
    echo '<div style="; background-color:#CCC">@'.__FILE__.' : '.__LINE__.'</div>';
    echo '<pre style="background-color: rgba(255,255,255, 0.8); color: #000">';
    print_r($_ENV);
    echo '</pre>';
echo '</div>';
echo '<hr/>';



echo '<h2>Database tests</h2>';

if (!isset($_ENV['MYSQL_USER']) || !isset($_ENV['MYSQL_PASSWORD'])) {
    die("Missing MYSQL_USER or MYSQL_PASSWORD env vars");
}


$host = 'mariadb'; // resolved by kubernetes internal DNS
$user = $_ENV['MYSQL_USER'] ?? 'root';
$password = $_ENV['MYSQL_PASSWORD'] ?? 'secret-root-pass';
$dbname = 'testdb';


try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Connexion réussie à MariaDB!";
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}

// show tables

$sql = "SHOW TABLES";
$stmt = $pdo->query($sql);
$tables = $stmt->fetchAll(PDO::FETCH_COLUMN);
echo "<h3>Tables list</h3>";
echo "<ul>";
foreach ($tables as $table) {
    echo "<li>$table</li>";
}
echo "</ul>";

echo "<h3>Records from logs</h3>";
//  select * from logs
$sql = "SELECT * FROM logs";
$stmt = $pdo->query($sql);
$logs = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo "<h3>Logs:</h3>";
echo "<table>";

echo '<thead><tr>';
foreach ($logs[0] as $index => $entry) {
        echo "<th>$index</th>";
}
echo '</tr></thead>';

foreach ($logs as $index => $entry) {
    echo "<tr>";
    foreach ($entry as $key => $value) {
        echo "<td>$value</td>";
    }
    echo "</tr>";
}
echo "</table>";

?>

</body>
</html>