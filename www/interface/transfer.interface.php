<?php

namespace BankSystem;

interface TransferInterface
{
    public function transferMoney($fromAccount, $toAccount, $amount);
}
