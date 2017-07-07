<?php
namespace TimeSeriesAnalysisWebApi\libs\database;

use Exception;
use \TimeSeriesAnalysisWebApi\models\TimeSeries;
use \TimeSeriesAnalysisWebApi\libs\utils\Config;

final class TimeSeriesDB extends Database {
    /** @var TimeSeriesDB */
    private static $instance;

    /** @var TimeSeriesDataDB */
    private $timeSeriesDataDB;

    /** @var Config */
    private $config;

    protected function __construct() {
        parent::__construct();

        $this->config = Config::getInstance();
        $this->dbname = $this->config->get("database", "name");
        $this->timeSeriesDataDB = new InfluxDB();
    }

    public static function getInstance() {
        if (!self::$instance instanceof self) {
            self::$instance = new self;
        }
        return self::$instance;
    }

    public function insert(TimeSeries $ts = null) {
        if($ts == null) {
            throw new Exception('Error creating timeseries: missing data');
        }

        if (!$ts->getData()) {
            throw new Exception('Error creating timeseries: missing timeseries data');
        }

        if (!$ts->getParameter('username')) {
            throw new Exception('Error creating timeseries: missing username');
        }

        if ($this->get($ts->getID())) {
            throw new Exception('Error creating timeseries: timeseries id exists');
        }

        if (!UserDB::getInstance()->get($ts->getParameter('username'))) {
            throw new Exception('Error creating timeseries: user not found');
        }

        $id = $ts->getID();
        $parameters_query = "";
        $values_query = "";

        foreach($ts->getParameters() as $parameter=>$value) {
            $parameters_query .= ", $parameter";
            $values_query .= ", '$value'";
        }

        $this->query = "INSERT INTO timeseries (id" . $parameters_query . ") VALUES('$id'" . $values_query . ");";
        $error = $this->execute_single_query();

        if(is_string($error) && $error != '') {
            throw new Exception('Error creating timeseries: ' . $error);
        }

        $timeSeries = $this->get($id);

        if(!$timeSeries) {
            throw new Exception('Error creating timeseries: insert database error');
        }

        try {
            $database = $ts->getParameter('username');
            $timeSeriesData = $ts->getData();

            $this->timeSeriesDataDB->insert($database, $id, $timeSeriesData);
        } catch (Exception $ex) {
            $this->delete($id, false);

            throw new Exception('Error creating timeseries: ' . $ex->getMessage());
        }

        return $timeSeries;
    }

    private function queryGet($filter = "", $page = 1) {
        $timeSeriesPerPage = 10;

        $offset = $timeSeriesPerPage * ($page - 1);

        return "SELECT * FROM timeseries " . $filter . " LIMIT " . $timeSeriesPerPage . " OFFSET " . $offset;
    }

    private function executeGetQuery($filter, $withData = false, $page = 1) {
        $this->query = $this->queryGet($filter, $page);

        $error = $this->get_results_from_query();

        if(is_string($error) && $error != '') {
            throw new Exception('Error getting timeseries: ' . $error);
        }

        $result = [];
        if(count($this->rows) >= 1) {
            foreach ($this->rows as $row) {
                $id = $row["id"];
                $timeSeriesData = null;

                if($withData) {
                    $database = $row['username'];
                    $timeSeriesData = $this->timeSeriesDataDB->get($database, $id);
                }

                $result[] = new TimeSeries($row["id"], $row, $timeSeriesData);
            }

            return $result;
        } else {
            return false;
        }
    }

    public function get($id = null, $withData = false, $page = 1) {
        $filter = $id != null ? "WHERE id = '$id'" : "";
        $result = $this->executeGetQuery($filter, $withData, $page);

        if (!is_bool($result)) {
            return count($result) > 1 ? $result : $result[0];
        }

        return false;
    }

    public function getPublic() {
        $filter = "WHERE public='1'";

        return $this->executeGetQuery($filter);
    }

    public function getIds($withNValues = false, $maxNValues = 0) {
        $this->query = "SELECT id, nvalues from timeseries WHERE public='1'";

        if ($maxNValues > 0) {
            $this->query .= " AND nvalues <= '$maxNValues'";
        }

        $error = $this->get_results_from_query();

        if(is_string($error) && $error != '') {
            throw new Exception('Error getting timeseries ids: ' . $error);
        }

        $result = [];

        if ($withNValues) {
            foreach ($this->rows as $row) {
                $result[] =  array($row["id"], $row["nvalues"]);
            }
        } else {
            foreach ($this->rows as $row) {
                $result[] =  $row["id"];
            }
        }

        return $result;
    }

    public function count() {
        $this->query = "SELECT COUNT(*) FROM timeseries WHERE public='1'";
        $error = $this->get_results_from_query();

        if(is_string($error) && $error != '') {
            throw new Exception('Error getting public timeseries: ' . $error);
        }

        return $this->rows[0]['COUNT(*)'];
    }

    public function getFromUser($username) {
        $filter = "WHERE username='$username'";

        return $this->executeGetQuery($filter);
    }

    public function update(TimeSeries $ts = null) {
        throw new Exception('Error updating TimeSeries: disabled');
    }
    
    public function delete($id = null, $data = true) {
        if($id == null) {
            throw new Exception('Error deleting timeseries: missing data');
        }
        $timeSeries= $this->get($id);

        if(!$timeSeries) {
            throw new Exception('Error deleting timeseries: not found');
        }

        $this->query = "DELETE FROM timeseries WHERE id='$id'";
        $error = $this->execute_single_query();

        if(is_string($error) && $error != '') {
            throw new Exception('Error Deleting timeseries: ' . $error);
        }

        if ($data) {
            try {
                $database = $timeSeries->getParameter('username');
                $this->timeSeriesDataDB->delete($database, $id);
            } catch(Exception $ex) {
                throw new Exception('Error Deleting timeseries: ' . $ex->getMessage());
            }
        }

        return true;
    }

    public function validateTimeSeries($id) {
        if ($this->get($id)) {
            return false;
        }

        return true;
    }

    public function createTimeSeriesDataDatabaseForUser($username) {
        $this->timeSeriesDataDB->createDatabase($username);
    }
}
