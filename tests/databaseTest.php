<?php

namespace Tests;

use PHPUnit\Framework\TestCase;
use BankSystem\Database;

class DatabaseTest extends TestCase
{
    protected $database;

    private $idsToRemove = array();

    public function setUp(): void
    {
        require_once('vendor/autoload.php');
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
        } catch (\Exception $error) {
            $this->markTestSkipped("Something went wrong while loading database. " .
            $error->getMessage());
        }
    }

    public function testConnection()
    {
        try {
            $isConnected = $this->database->connect();
        } catch (\Exception $error) {
            $this->fail("Could not connect to database: " . $error->getMessage());
        }

        $this->assertTrue($isConnected);

        return $this->database;
    }
    /**
     * @depends testConnection
     */
    public function testQueryWithoutBinds($database)
    {
        $sql = "SELECT * FROM users";

        $rows = $database->query($sql);

        $this->assertGreaterThan(0, $rows);

        return $database;
    }

    /**
     * @depends testQueryWithoutBinds
     */

    public function testFetchedRow($database)
    {
        $shouldBeArray = $database->getFetchedRow();

        $this->assertIsArray($shouldBeArray);
    }
    /**
     * @depends testConnection
     */
    public function testInsertData($database)
    {
        $sql = "INSERT INTO users ( firstName, lastName, username, password ) VALUES ( ?, ?, ?, ?)";
        $dataToInsert = array(
            "testFirstName",
            "testLastName",
            "testUsername",
            "testPassword"
        );

        $row = $database->query($sql, $dataToInsert);

        $this->assertGreaterThan(0, $row);
        $this->idsToRemove[] = $database->getLastId();
    }

    public function tearDown(): void
    {
        $this->database->connect();
        foreach ($this->idsToRemove as $id) {
            $sql = "DELETE FROM users WHERE user_accountNumber = ?";
            $this->database->query($sql, [$id]);
        }
    }
}
