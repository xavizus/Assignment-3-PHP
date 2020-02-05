<?php

namespace Tests;

use PHPUnit\Framework\TestCase;
use BankSystem\Database;
use API\Users;

class ApiTest extends TestCase
{
    protected $database;
    protected $api;
    protected $idToRemove;

    public function setUp(): void
    {
        require_once('vendor/autoload.php');
        require_once("www/classes/api/api.class.php");
        require_once('www/classes/api/users.class.php');
        require_once("www/classes/database.class.php");
        $dotenv = \Dotenv\Dotenv::createImmutable(__DIR__ . "/../");
        $dotenv->load();
        $databaseConfig = array(
            "dbhost" => $_ENV['DBHOST'],
            "dbname" => $_ENV['DBNAME'],
            "username" => $_ENV['DBUSER'],
            "password" => $_ENV['DBPASSWORD'],
            "dbport" => $_ENV['DBPORT']
        );
        try {
            $this->database = new Database($databaseConfig);
            $this->api = new Users($this->database);
        } catch (\Exception $error) {
            $this->markTestSkipped("Something went wrong while loading database. " .
            $error->getMessage());
        }
    }

    public function testGetWithoutId()
    {
        $sql = $this->api->get();
        $this->assertIsArray($sql);
        $this->assertGreaterThanOrEqual(1, count($sql));
    }

    public function testGetWithId()
    {
        $sql = $this->api->get(2);
        $this->assertIsArray($sql);
        $this->assertEquals(1, count($sql));
    }

    public function testGetWithNonsens()
    {
        $this->expectException("TypeError");
        $sql = $this->api->get("h");
    }

    public function testPostData()
    {
        $testData = array(
            'firstName' => "firstName",
            'lastName' => "lastName",
            'username' => "username",
            'password' => "password",
            "phoneNumber" => "phoneNumber",
            "creditCard" => "0785461616"
        );
        $this->idToRemove = $this->api->post($testData);

        $this->assertIsNumeric($this->idToRemove);
    }

    public function tearDown(): void
    {
        if (!empty($this->idToRemove)) {
            $sql = "DELETE FROM users WHERE user_accountNumber = :user_accountNumber";
            $this->database->query($sql, array("user_accountNumber" => $this->idToRemove));
        }
    }
}
