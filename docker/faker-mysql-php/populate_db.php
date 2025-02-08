<?php
require 'vendor/autoload.php';  // Charger Faker et MySQL

use Faker\Factory;

// Paramètres de connexion à MariaDB
$host = getenv('DB_HOST') ?: 'mariadb';
$user = getenv('DB_USER') ?: 'root';
$password = getenv('DB_PASS') ?: 'secret-root-pass';
$dbname = getenv('DB_NAME') ?: 'testdb';
$num_users = getenv('NUM_USERS') ?: 100;
$num_products = getenv('NUM_PRODUCTS') ?: 50;
$num_orders = getenv('NUM_ORDERS') ?: 500;
$num_logs = getenv('NUM_LOGS') ?: 1000;

echo "🚀 Initialisation de la base de données...\n";
echo "ℹ️ Connection parameters : \n";
echo "  - Host : $host\n";
echo "  - User : $user\n";
echo "  - Password : $password\n";

// create database
echo "🔧 Creating database " . $dbname  . "\n";
try {
    $pdo = new PDO("mysql:host=$host", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->exec("CREATE DATABASE IF NOT EXISTS $dbname");
    echo "✅ Base de données créée avec succès !\n";
} catch (PDOException $e) {
    die("❌ Erreur : " . $e->getMessage());
}



try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $faker = Factory::create();

    // Création des tables
    $pdo->exec("CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255),
        email VARCHAR(255) UNIQUE,
        address TEXT,
        phone VARCHAR(20),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");

    $pdo->exec("CREATE TABLE IF NOT EXISTS products (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255),
        description TEXT,
        price DECIMAL(10,2),
        stock INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");

    $pdo->exec("CREATE TABLE IF NOT EXISTS orders (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT,
        product_id INT,
        quantity INT,
        total_price DECIMAL(10,2),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (product_id) REFERENCES products(id)
    )");

    $pdo->exec("CREATE TABLE IF NOT EXISTS logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        level ENUM('INFO', 'WARNING', 'ERROR'),
        message TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");

    // Insérer des utilisateurs
    $stmt = $pdo->prepare("INSERT INTO users (name, email, address, phone) VALUES (?, ?, ?, ?)");
    for ($i = 0; $i < $num_users; $i++) {
        $stmt->execute([$faker->name(), $faker->email(), $faker->address(), $faker->phoneNumber()]);
    }

    // Insérer des produits
    $stmt = $pdo->prepare("INSERT INTO products (name, description, price, stock) VALUES (?, ?, ?, ?)");
    for ($i = 0; $i < $num_products; $i++) {
        $stmt->execute([$faker->word(), $faker->sentence(), $faker->randomFloat(2, 5, 500), $faker->numberBetween(1, 100)]);
    }

    // Insérer des commandes
    $stmt = $pdo->prepare("INSERT INTO orders (user_id, product_id, quantity, total_price) VALUES (?, ?, ?, ?)");
    for ($i = 0; $i < $num_orders; $i++) {
        $user_id = $faker->numberBetween(1, $num_users);
        $product_id = $faker->numberBetween(1, $num_products);
        $quantity = $faker->numberBetween(1, 5);
        $price = $pdo->query("SELECT price FROM products WHERE id = $product_id")->fetchColumn();
        $stmt->execute([$user_id, $product_id, $quantity, $quantity * $price]);
    }

    // Insérer des logs
    $stmt = $pdo->prepare("INSERT INTO logs (level, message) VALUES (?, ?)");
    $log_levels = ['INFO', 'WARNING', 'ERROR'];
    for ($i = 0; $i < $num_logs; $i++) {
        $stmt->execute([$faker->randomElement($log_levels), $faker->sentence()]);
    }

    echo "✅ Base de données remplie avec succès !\n";

} catch (PDOException $e) {
    die("❌ Erreur : " . $e->getMessage());
}
