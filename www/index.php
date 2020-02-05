<?PHP

session_start();

$_SESSION['username'] = "emcdougall0";
$_SESSION['user_id'] = 1;
$_SESSION['firstName'] = "Eugenius";
$_SESSION['lastName'] = "McDougall";
$_SESSION['phoneNumber'] = "0742468397";
$_SESSION['user_accountNumber'] = 3574737;
$_SESSION['creditCard'] = 3580744680863458;

require_once(__DIR__ . '/public/hmtl/header.php');
require_once('../vendor/autoload.php');

?>
<h1>Welcome <?=$_SESSION['firstName'] . " " . $_SESSION['lastName']?>! </h1>
<p>You got <span id="balance"></span> <span id="currency"></span> in your account!</p>
<form id="skickaPengar" method="post">
    <select name="to_account" id="to_account">
    </select>
    <select name="sendType" id="sendType">
        <option value="bank">Bank</option>
        <option value="switch">Switch</option>
        <option value="creditCard">Credit Card</option>
    </select>
    <input type="number" name="amount" id="amount">
    <button type="submit" id="sendMoney">Send money!</button>
</form>

<div id="message"></div>