<?php

namespace BankSystem;

class Transfer
{
    private $payment;
    public function __construct(TransactionInterface $payment)
    {
        $this->payment = $payment;
    }

    public function transferPayment()
    {
        return $this->payment->exceuteTransfer();
    }
}
