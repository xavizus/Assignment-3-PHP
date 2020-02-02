<?php

namespace API;

class API
{
    protected $database;
    protected $table;

    public function __construct(BankSystem\Database $database)
    {
        $this->database = $database;
    }

    public function get($id = null)
    {
        $sql = "SELECT * FROM ${$this->table}";
    }
}
