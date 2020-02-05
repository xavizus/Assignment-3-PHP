<?php

namespace BankSystem;

class BankTransaction extends Transaction implements TransactionInterface
{
    protected $uniqueColumn = "user_accountNumber";
}
