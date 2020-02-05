<?php
session_start();
require_once('../vendor/autoload.php');
require_once("./classes/database.class.php");
require_once('./api/api.class.php');

$dotenv = \Dotenv\Dotenv::createImmutable(__DIR__ . "/../");
$dotenv->load();

$databaseConfig = array(
    "dbhost" => $_ENV['DBHOST'],
    "dbname" => $_ENV['DBNAME'],
    "username" => $_ENV['DBUSER'],
    "password" => $_ENV['DBPASSWORD'],
    "dbport" => $_ENV['DBPORT']
);

$response = [
    'info' => null,
    'result' => null
];

try {
    $database = new BankSystem\Database($databaseConfig);
    $database->connect();
    $api = new API\API($database);
} catch (\Exception $error) {
    http_response_code(503);
    $response['info']['errorCode'] = $error->getCode();
    $response['info']['message'] = $error->getMessage();
    header("Content-Type: application/json; charset=UTF-8");
    echo json_encode($response);
    exit;
}

if (isset($_GET['Transaction'])) {
    if (isset($_GET['type'])) {
        try {
            require_once('./interface/transaction.interface.php');
            require_once('./classes/transaction.class.php');
            require_once('./classes/transfer.class.php');
            require_once("./classes/$_GET[type]transaction.class.php");
        } catch (\Exception $error) {
            http_response_code(503);
            $response['info']['errorCode'] = $error->gerCode();
            $response['info']['message'] = "Desired type does not exist!";
            header("Content-Type: application/json; charset=UTF-8");
            echo json_encode($response);
            exit;
        }

        if (empty($_GET['to']) || empty($_GET['amount'])) {
            $response['info']['errorCode'] = 0;
            $response['info']['message'] = "Either to, or amount missing";
            header("Content-Type: application/json; charset=UTF-8");
            echo json_encode($response);
            exit;
        }
        
        try {
            $uniqueIdentifier;
            switch ($_GET['type']) {
                case ('bank'):
                    $uniqueIdentifier = 'user_accountNumber';
                    break;
                case ('switch'):
                    $uniqueIdentifier = 'phoneNumber';
                    break;
                case ('creditcard'):
                    $uniqueIdentifier = 'creditCard';
                    break;
                default:
                    $uniqueIdentifier = null;
            }
            if (empty($uniqueIdentifier)) {
                throw new Exception("Missing identifyer");
            }
            $transactionClass = 'BankSystem\\' . ucfirst($_GET['type']) . 'Transaction';
            $transaction = new $transactionClass(
                $database,
                $_SESSION[$uniqueIdentifier],
                $_GET['to'],
                (int)$_GET['amount']
            );
            $transfer = new BankSystem\Transfer($transaction);
            $transfer->transferPayment();
            $response['info']['code'] = "OK";
            $response['result'] = "The transfer were successfull!";
            header("Content-Type: application/json; charset=UTF-8");
            echo json_encode($response);
            exit;
        } catch (\Exception $error) {
            $response['info']['errorCode'] = 0;
            $response['info']['message'] = $error->getMessage();
            if ($error->getCode() == 1337) {
                $response['img'] = "<img src='./public/images/money-is-no-more.jpg'><br>";
            }
            header("Content-Type: application/json; charset=UTF-8");
            echo json_encode($response);
            exit;
        } catch (\ArgumentCountError $error) {
            $response['info']['errorCode'] = 0;
            $response['info']['message'] = "Missing Arguments!";
            header("Content-Type: application/json; charset=UTF-8");
            echo json_encode($response);
            exit;
        }
    }
}

if (isset($_GET['getAllUsers'])) {
    try {
        $data = $api->getAllUsers($_SESSION['user_id']);
        echo json_encode($data);
    } catch (\Exception $error) {
        echo $error->getMessage();
    }
}

if (isset($_GET['getBalanceAndCurrencyByUserId'])) {
    try {
        $data = $api->getBalanceAndCurrencyByUserId($_SESSION['user_id']);
        echo json_encode($data);
    } catch (\Exception $error) {
        echo json_encode($error->getMessage());
    }
}

if (isset($_GET['getCurrentUserData'])) {
    if (!isset($_SESSION['user_accountNumber'])) {
        echo "You are not a vaild user";
        exit;
    }
    $data = $api->getCurrentUserData($_SESSION['user_id']);
    echo json_encode($data);
}
