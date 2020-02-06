<?php
 $url = 'https://api.exchangeratesapi.io/latest?base=SEK&symbols=USD';
         $ch = curl_init($url);
         curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
         curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
         curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
         $results = curl_exec($ch);
         curl_close($ch);
         print_r($results);