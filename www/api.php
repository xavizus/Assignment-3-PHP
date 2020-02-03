<?php

require_once('../vendor/autoload.php');
require_once("classes/database.class.php");
require_once('classes/api/api.class.php');

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
    $database = new BankSystem\Database($databaseConfig);
} catch (\Exception $error) {
    print_r($error->getMessage());
    exit;
}

$requestMethod = $_SERVER['REQUEST_METHOD'];

foreach (array_keys($_GET) as $className) {
    error_log($className);
    if (file_exists("classes/api/" . strtolower($className) . ".class.php")) {
        if (strpos(strToLower($className), "transfer") !== false) {
            require_once("interface/transaction.interface.php");
        }
        require_once("classes/api/" . $className . ".class.php");
        $className = '\\API\\' . $className;
        $api = new $className($database);
    } else {
        http_response_code(400);
        exit;
    }
}

if (isset($_GET['transfer']) && $_GET['transfer'] == "true") {
    error_log("Vi har fått ett request av typ: $requestMethod och önskad data är " . implode(", ", array_keys($_GET)));
    error_log("Vi har fått följande data i POST: $_POST[formUserId], $_POST[toUserId], $_POST[amount]");

    $dataToSend = array(
        "transaction_id" => null,
        "amount" => $_POST['amount'],
        "from_user_accountNumber" => $_POST['formUserId'],
        "to_user_accountNumber" => $_POST['toUserId'],
        "date" => time(),
        "currency" => "SEK"
    );

    $ID = $api->post($dataToSend);

    error_log("ID: $ID");
} elseif (isset($_GET['users'])) {
    $ID2 = $api->get();
    print_r($ID2);
}
