<?php

namespace API;

class API
{
    private $database;
     
    public function __construct(\BankSystem\Database $database)
    {
        if (!isset($_SESSION['user_id'])) {
                throw new \Exception("User missing session! Try to login first!");
        }

        $this->database = $database;
    }

    /**
     * @param int
     * @throws \Exception
     * @return int
     */

    public function getBalanceAndCurrencyByUserId(int $id)
    {
        $sql = "SELECT balance.balance, users.currency
        FROM users
        LEFT JOIN userBalanceRelation ubr on ubr.user_id = users.user_id
        LEFT JOIN balance on balance.balance_id = ubr.balance_id
        WHERE users.user_id = ?";

        $statement = $this->database->query($sql, [$id]);

        if ($statement == 0) {
            throw new \Exception("No balanceaccount matched to the id: $id.");
        }

        $data = $this->database->getFetchedRow();

        return $data;
    }

    public function getCurrentUserData(int $id)
    {
        $sql = "SELECT *
        FROM users
        WHERE user_accountNumber = ?";

        $statement = $this->database->query($sql, [$id]);

        if ($statement == 0) {
            throw new \Exception("No balanceaccount matched to the id: $id.");
        }

        $data = $this->database->getFetchedRow();

        return $data;
    }

    public function getAllUsers($exceptThisId = null)
    {
        $sql = "SELECT *
        FROM users";
        if (!empty($exceptThisId)) {
            $sql .= " WHERE user_id != ?";
        }

        $statement = $this->database->query($sql, [$exceptThisId]);

        if ($statement == 0) {
            throw new \Exception("There are no users! \u{1F631}");
        }

        $data = $this->database->getFetchedAll();

        return $data;
    }
}
