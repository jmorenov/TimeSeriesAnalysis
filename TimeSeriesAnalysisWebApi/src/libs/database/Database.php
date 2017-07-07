<?php
namespace TimeSeriesAnalysisWebApi\libs\database;

use \MySQLi;
use \TimeSeriesAnalysisWebApi\libs\utils\Config;

abstract class Database implements IDatabase {
    private static $host;
    private static $user;
    private static $pass;
    private static $port;

    /** @var MySQLi */
    private $conn;

    protected $dbname;
    protected $query;
    protected $rows = array();
    
    protected function __construct() {
        self::$host = Config::getInstance()->get("database", "host");
        self::$user = Config::getInstance()->get("database", "user");
        self::$pass = Config::getInstance()->get("database", "pass");
        self::$port = Config::getInstance()->get("database", "port");
    }
    
    private function open_connection() {
        $this->conn = new MySQLi(self::$host, self::$user, self::$pass, $this->dbname, self::$port);

        return $this->conn->errno;
    }
    
    private function close_connection() {
        $this->conn->close();
    }
    
    protected function execute_single_query() {
        $this->open_connection();
        $this->conn->query($this->query);
        $error = $this->conn->error;
        $this->close_connection();

        return $error;
    }

    protected function execute_multiple_query() {
        $this->open_connection();
        $this->conn->multi_query($this->query);
        $error = $this->conn->error;
        $this->close_connection();

        return $error;
    }
    
    protected function get_results_from_query() {
        $this->open_connection();
        $result = $this->conn->query($this->query);
        $error = $this->conn->error;
        $this->rows = array();
        if($result) {
            while ($this->rows[] = $result->fetch_assoc()) {
                
            }
            $result->close();
            $this->close_connection();
            array_pop($this->rows);
        }
        return $error;
    }
}
