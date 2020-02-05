<?php

namespace BankSystem;

interface TransactionInterface
{
    public function __construct(\BankSystem\Database $database, $fromAccount, $toAccount, $amount);

    public function exceuteTransfer();

    public function checkIfEnoughFromAccountGotEnoughAmount();

    public function checkIfCurrencyDiffersFromAccounts();

    public function getRatioDifference($base, $to_currency);

    public function getUserIdFromUniqueColumn($uniqueIdentifier);
}
