<?php

namespace API;

abstract class API
{
    protected $database;
    protected $table;
    protected $idName;
    protected $requiredFieldsWithDataTypes;

    /**
     * @param \BankSystem\Database
     */
    abstract public function __construct(\BankSystem\Database $database);

    /**
     * @param int $id
     * @return array
     */

    public function get(int $id = null)
    {
        $sql = "SELECT * FROM $this->table";

        if ($id !== null) {
            $sql .= " WHERE $this->idName = ?";
        }

        if ($id == null) {
            $this->database->query($sql);
        } else {
            $this->database->query($sql, [$id]);
        }

        $data = $this->database->getFetchedAll();

        return $data;
    }

    /**
     * @param array $data
     * @return int
     * @throws Exception
     */
    
    public function post(array $data)
    {
        $data[$this->idName] = null;

        try {
            $this->requiredKeysInArray($data);
        } catch (\Exception $error) {
            throw new \Exception("Failed requireKeysInArray reson: " . $error->getMessage());
        }
        $sql = "INSERT INTO $this->table (" . implode(', ', array_column($this->requiredFieldsWithDataTypes, 'Field')) .
        ") " . "VALUES (:" . implode(", :", array_column($this->requiredFieldsWithDataTypes, 'Field')) . ")";

        $this->database->query($sql, $data);

        return $this->database->getLastId();
    }

    /**
     * @param array $data
     * @return boolean
     * @throws Exception
     */
    private function requiredKeysInArray(array $arrayToCheck)
    {
        $missingKeys = array();
        $requiredKeys = array_column($this->requiredFieldsWithDataTypes, 'Field');
        foreach ($requiredKeys as $requiredKey) {
            if (!array_key_exists($requiredKey, $arrayToCheck)) {
                $missingKeys[] = $requiredKey;
            }
        }

        if (!empty($missingKeys)) {
            throw new \Exception("There are missing key(s): " . implode(', ', $missingKeys));
        }
        return true;
    }

    /**
     * @return array
     */
    protected function getTableFields()
    {
        $sql = "DESCRIBE $this->table";

        $this->database->query($sql);
        $columns = $this->database->getFetchedAll();
        return $columns;
    }
}
