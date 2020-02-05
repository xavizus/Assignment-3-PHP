<?php

namespace BankSystem;

class CreditcardTransaction extends Transaction implements TransactionInterface
{
    protected $uniqueColumn = "creditCard";
}
