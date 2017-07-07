<?php
namespace TimeSeriesAnalysisWebApi\libs\database;

use Exception;
use TimeSeriesAnalysisWebApi\libs\utils\Config;
use TimeSeriesAnalysisWebApi\libs\utils\Date;

final class ClusteringDB extends Database {
    /** @var ClusteringDB */
    private static $instance;

    /** @var Config */
    private $config;

    protected function __construct() {
        parent::__construct();

        $this->config = Config::getInstance();
        $this->dbname = $this->config->get("database", "name");
    }

    public static function getInstance() {
        if (!self::$instance instanceof self) {
            self::$instance = new self;
        }
        return self::$instance;
    }

    public function get() {
        $this->query = "SELECT * from clustering ORDER BY date DESC";

        $error = $this->get_results_from_query();

        if(is_string($error) && $error != '') {
            throw new Exception('"Error getting clustering: ' . $error);
        }

        if (count($this->rows) > 0) {
            $result = [];
            foreach ($this->rows as $row) {
                $result[] = json_decode($row['results']);
            }

            return $result[0];
        }

        return false;
    }

    public function insert($centers = null) {
        if ($centers == null) {
            throw new Exception("Error inserting clustering: missing fields.");
        }

        $timezone = $this->config->get("main", "default_timezone");
        $date = new Date(date("Y-m-d H:i:s"), "Y-m-d H:i:s", $timezone);
        $date = $date->getDate();
        $centersEncoded = json_encode($centers);
        $this->query = "INSERT INTO clustering (date, results) VALUES('$date', '$centersEncoded')";
        $error = $this->execute_single_query();

        if(is_string($error) && $error != '') {
            throw new Exception('Error inserting complexity measures: ' . $error);
        }

        return true;
    }

    public function delete() {

    }

    public function update() {

    }
}