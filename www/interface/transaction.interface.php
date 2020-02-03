<?php

namespace BankSystem;

interface TransactionInterface
{
    public function __construct($fromAccount, $toAccount, $amount);

    public function exceuteTransfer();

    public function checkIfEnoughFromAccountGotEnoughAmount();

    public function checkIfCurrencyDiffersFromAccount();

    public function getRatioDifference();
}
