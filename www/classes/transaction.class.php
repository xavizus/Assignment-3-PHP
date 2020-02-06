<?php

namespace BankSystem;

class Transaction
{
    /**
     * Required to be set.
     */
    protected $uniqueColumn;

    private $database;
    private $from_userid;
    private $to_userid;
    private $from_amount;
    private $to_amount;
    private $from_currency;
    private $to_currency;
    private $ratio = 1;

    private static $requiredChecks = array ();

    public function __construct(\BankSystem\Database $database, $fromAccount, $toAccount, $amount)
    {
        if ($fromAccount == $toAccount) {
            throw new \Exception("You cant transfer to yourself!");
        }
        $this->database = $database;
        $this->to_userid = $this->getUserIdFromUniqueColumn($toAccount);
        $this->from_userid = $this->getUserIdFromUniqueColumn($fromAccount);
        $this->from_amount = $amount;
    }

    public function exceuteTransfer()
    {
        $enoughMoney = $this->checkIfEnoughFromAccountGotEnoughAmount();
        if (!$enoughMoney) {
            throw new \Exception("You are broke as fuck!", 1337);
        }
        $results = $this->checkIfCurrencyDiffersFromAccounts();
        if (is_array($results)) {
            $from_index = $this->searchMultidimentionalArray(
                $this->from_userid,
                $results,
                'user_id'
            );
            $to_index = $this->searchMultidimentionalArray(
                $this->to_userid,
                $results,
                'user_id'
            );
            $this->from_currency = $results[$from_index]['currency'];
            $this->to_currency = $results[$to_index]['currency'];
            $this->ratio = $this->getRatioDifference($this->from_currency, $this->to_currency);
            $this->to_amount = intval($this->from_amount * $this->ratio);
        } else {
            $this->from_currency = $results;
            $this->to_currency = $results;
            $this->to_amount = $this->from_amount;
        }

        $sql = "CALL createTransfer( 
            :amount_from, 
            :amount_to, 
            :from_user_id, 
            :to_user_id, 
            :currency_from, 
            :currency_to, 
            :ratio)";

        $preparedArray = array(
            "amount_from" => $this->from_amount,
            "amount_to" => $this->to_amount,
            "from_user_id" => $this->from_userid,
            "to_user_id" => $this->to_userid,
            "currency_from" => $this->from_currency,
            "currency_to" => $this->to_currency,
            "ratio" => $this->ratio
        );
        
        $rows = $this->database->query($sql, $preparedArray);

        if ($rows != 3) {
            return false;
        }

        return $enoughMoney - $this->from_amount;
    }

    public function checkIfEnoughFromAccountGotEnoughAmount()
    {
        $sql = "SELECT balance.balance
        FROM users
        LEFT JOIN userBalanceRelation ubr on ubr.user_id = users.user_id
        LEFT JOIN balance on balance.balance_id = ubr.balance_id
        WHERE users.user_id = ?";

        $rows = $this->database->query($sql, [$this->from_userid]);

        if ($rows == 0) {
            throw new \Exception("Account could not be found!");
        }
        $data = $this->database->getFetchedRow();
        if ($data['balance'] >= $this->from_amount) {
            return $data['balance'];
        } else {
            return false;
        }
    }

    public function checkIfCurrencyDiffersFromAccounts()
    {
        $sql = "SELECT users.currency, users.user_id
        FROM users
        LEFT JOIN userBalanceRelation ubr on ubr.user_id = users.user_id
        LEFT JOIN balance on balance.balance_id = ubr.balance_id
        WHERE users.user_id = ? OR users.user_id = ?";

        $rows = $this->database->query($sql, [$this->from_userid, $this->to_userid]);


        if ($rows != 2) {
            throw new \Exception("Couldn't find both accounts!");
        }
        $results = $this->database->getFetchedAll();
        $amountOfSameCurrency = array_count_values(array_column($results, 'currency'));

        if (count($amountOfSameCurrency) > 1) {
            return $results;
        } else {
            return array_keys($amountOfSameCurrency)[0];
        }
    }

    private function searchMultidimentionalArray($needle, array $arrayToSearch, $keyToSearchIn)
    {
        $indexOfNeedle = array_search(
            $needle,
            array_column($arrayToSearch, $keyToSearchIn)
        );

        return  $indexOfNeedle;
    }

    public function getRatioDifference($base, $to_currency)
    {
        $url = "https://api.exchangeratesapi.io/latest?base=$base&symbols=$to_currency";
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

        $results = json_decode(curl_exec($curl));

        return $results->rates->$to_currency;
    }

    public function getUserIdFromUniqueColumn($uniqueIdentifier)
    {
        $sql = "SELECT user_id
        FROM users
        WHERE $this->uniqueColumn = ?";
        $this->database->query($sql, [$uniqueIdentifier]);
        $user_id = $this->database->getFetchedRow()['user_id'];
        if (empty($user_id)) {
            throw new \Exception("User with $this->uniqueColumn: $uniqueIdentifier does not exists");
        }
        return $user_id;
    }
}
