<?php

namespace API;

class Users extends API
{
    protected $table = "users";
    protected $idName = "user_accountNumber";

    public function __construct(\BankSystem\Database $database)
    {
        $this->database = $database;
        $this->database->connect();

        $this->requiredFieldsWithDataTypes = $this->getTableFields();
    }
}
