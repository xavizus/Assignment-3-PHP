<?php

namespace API;

class Transfer extends API
{
    protected $table = "transactions";
    protected $idName = "transaction_id";

    public function __construct(\BankSystem\Database $database, \BankSystem\TransactionInterface $interface)
    {
        $this->database = $database;
        $this->database->connect();

        $this->requiredFieldsWithDataTypes = $this->getTableFields();
    }


    public function post(array $data)
    {
        $data[$this->idName] = null;

        try {
            $this->requiredKeysInArray($data);
        } catch (\Exception $error) {
            throw new \Exception("Failed requireKeysInArray reson: " . $error->getMessage());
        }

        $data = $this->getUserBalance(1);
        print_r($data);
    }

    public function getUserBalance($id)
    {
        $sql = "SELECT balance.balance
        FROM users
        LEFT JOIN userBalanceRelation ubr on ubr.user_accountNumber = users.user_accountNumber
        LEFT JOIN balance on balance.balance_id = ubr.balance_id
        WHERE users.user_accountNumber = :id";

        $this->database->query($sql);

        return $this->database->getFetchedRow();
    }
}
