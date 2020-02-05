<?php

namespace BankSystem;

class SwishTransaction extends Transaction implements TransactionInterface
{
    protected $uniqueColumn = "phoneNumber";
}
