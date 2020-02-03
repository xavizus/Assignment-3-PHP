<?php

namespace BankSystem;

use PDO;

class Database
{
    private static $requiredConfigs = array(
        "dbhost",
        "dbname",
        "username",
        "password"
    );

    private $dataSourceName;
    private $user;
    private $password;
    private $pdo;
    private $statement;
    private $lastInsertId;
    private $options =
    [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ];
    /**
     * @param array $databaseConfig
     * @throws \Exception
     */
    public function __construct(array $databaseConfig)
    {
        try {
            $missingKeys = array();
            foreach (self::$requiredConfigs as $requiredKey) {
                if (array_key_exists($requiredKey, $databaseConfig)) {
                    $key = $requiredKey;
                    $$key = $databaseConfig[$requiredKey];
                } else {
                    $missingKeys[] = $requiredKey;
                }
            }
            if (!empty($missingKeys)) {
                throw new \Exception("Missing keys: " .  implode(", ", $missingKeys));
            }
        } catch (\Exception $error) {
            throw new \Exception("Error while loading configurations: " . $error->getMessage());
        }
        if (empty($dbport)) {
            $dbport = 3306;
        }
        $this->dataSourceName = "mysql:host=$dbhost;port=$dbport;dbname=$dbname";
        $this->password = $password;
        $this->user = $username;
    }

    /**
     * Connects to DB-server
     * @return bool
     * @throws Exception
     */
    public function connect()
    {
        try {
            if ($this->pdo instanceof \PDO) {
                return true;
            }
            $this->pdo = new \PDO($this->dataSourceName, $this->user, $this->password, $this->options);
            return true;
        } catch (\PDOException $error) {
            throw new \Exception("An error occured: " . $error->getMessage());
        }
    }
    /**
     * Starts a transaction and prepare data.
     * @param string $sqlStatement
     * @param array $dataToBind
     * @return integer if sucessfull
     * @throws Exceptions
     */

    public function query(string $sqlStatement, array $dataToBind = null)
    {
        try {
            $this->pdo->beginTransaction();
            $this->statement = $this->pdo->prepare($sqlStatement);
            if (is_array($dataToBind)) {
                foreach ($dataToBind as $key => $data) {
                    $dataType = PDO::PARAM_STR;
                    switch (true) {
                        case \is_null($data):
                            $dataType = PDO::PARAM_NULL;
                            break;
                        case \is_numeric($data):
                            $dataType = PDO::PARAM_INT;
                            break;
                        case is_bool($data):
                            $dataType = PDO::PARAM_BOOL;
                            break;
                    }
                    $this->statement->bindValue(":$key", $data, $dataType);
                }
            }
            $this->statement->execute($dataToBind);
            $this->lastInsertId = $this->pdo->lastInsertId();
            $this->pdo->commit();
        } catch (\PDOException $error) {
            $this->pdo->rollback();
            throw new \Exception("An error occured: " . $error->getMessage());
        }
        return $this->statement->rowCount();
    }

    /**
     * @return integer
     */
    public function getLastId()
    {
        return $this->lastInsertId;
    }

    /**
     * @return array
     */
    public function getFetchedRow()
    {
        return $this->statement->fetch();
    }

    /**
     * @return array
     */
    public function getFetchedAll()
    {
        return $this->statement->fetchAll();
    }
}
