<?php

namespace BankSystem;

class SwichTransaction extends Transaction implements TransactionInterface
{
    protected $uniqueColumn = "phoneNumber";
}
