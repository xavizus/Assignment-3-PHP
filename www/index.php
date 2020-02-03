<?PHP

use BankSystem\Database;

session_start();

$_SESSION['username'] = "emcdougall0";
$_SESSION['user_accountNumber'] = 1;
$_SESSION['firstName'] = "Eugenius";
$_SESSION['lastName'] = "McDougall";

require_once(__DIR__ . '\public\hmtl\header.php');


require_once('../vendor/autoload.php');
require_once("www/classes/database.class.php");
$dotenv = \Dotenv\Dotenv::createImmutable(__DIR__ . "/../");
$dotenv->load();
$databaseConfig = array(
    "dbhost" => $_ENV['DBHOST'],
    "dbname" => $_ENV['DBNAME'],
    "username" => $_ENV['DBUSER'],
    "password" => $_ENV['DBPASSWORD'],
    "dbport" => $_ENV['DBPORT']
);
try {
    $this->database = new Database($databaseConfig);
} catch (\Exception $error) {
    print_r($error->getMessage());
}

?>

<form id="skickaPengar" method="post">
    <input type="text" name="username" id="username">
</form>