<?php
namespace TimeSeriesAnalysisWebApi\libs\database;

use Exception;
use InfluxDB\Client;
use InfluxDB\Point;
use TimeSeriesAnalysisWebApi\libs\utils\Date;
use TimeSeriesAnalysisWebApi\libs\utils\Config;
use TimeSeriesAnalysisWebApi\models\TimeSeriesData;

final class InfluxDB extends TimeSeriesDataDB {
    /** @var Client */
    private $client;

    public function __construct() {
        parent::__construct();

        $this->client = new Client(parent::$host, parent::$port, parent::$user, parent::$pass);
    }

    public function get($dbname = null, $id = null) {
        //$database = $this->client->selectDB($dbname);
        $database = $this->client->selectDB(parent::$dbname);

        $points = $database->query("SELECT * FROM " . $id)->getPoints();
        $colnames = array_slice(array_keys($points[0]), 1);
        $dates = $data = [];

        foreach($points as $point) {
            $format = Date::ATOM;

            if($point['real_time'] != 'NULL') {
                $point['time'] = (int) $point[$colnames[1]];
                $format = 'U';
            }

            $dates[] = new Date($point['time'], $format, Config::getInstance()->get('main', 'default_timezone'));
            $data_i = [];

            for($i = 0; $i < count($colnames) - 1; $i++) {
                if($colnames[$i] != 'real_time') {
                    $data_i[] = (double) $point[$colnames[$i]];
                }
            }

            $data[] = $data_i;
        }

        $rownames = array();
        unset($colnames[count($colnames) - 1]);
        $colnames = array_values($colnames);

        return new TimeSeriesData($data, $dates, $rownames, $colnames);
    }

    private function existsId(/** @noinspection PhpUnusedParameterInspection */ $database, $id) {
        $database = $this->client->selectDB(parent::$dbname);

        return !empty($database->query("SELECT * FROM $id")->getPoints());
    }

    public function insert($dbname = null, $id = null, TimeSeriesData $data = null) {
        //$database = $this->client->selectDB($dbname);
        $database = $this->client->selectDB(parent::$dbname);

        if (!$database->exists()) {
            throw new Exception('Error Creating timeseries: user database not found.');
        }

        if ($this->existsId($dbname, $id)) {
            $this->delete($dbname, $id);
        }

        $points = [];
        $timestamp = $data->getTimestamp();

        for ($i = 0; $i < $data->nvalues(); $i++) {
            $values = [];

            for ($j = 0; $j < $data->nvars(); $j++) {
                $values[$data->getColnames()[$j]] = $data->getMeasure($i, $j);
            }

            if ($timestamp[$i] < 0) { //Before 1970
                $tags = ["real_time" => $timestamp[$i]];
            } else {
                $tags = ["real_time" => "NULL"];
            }

            $p = new Point($id, null, $tags, $values, abs($timestamp[$i]));
            $points[] = $p;
        }

        return $database->writePoints($points, \InfluxDB\Database::PRECISION_SECONDS);
    }

    public function createDatabase($dbname) {
        /*$this->client->query('_internal', 'CREATE DATABASE "' . $dbname . '"');

        $database = $this->client->selectDB($dbname);

        if (!$database->exists()) {
            throw new Exception('Error Creating user database: something failed.');
        }*/
    }

    public function delete($dbname = null, $id = null) {
        //$database = $this->client->selectDB($dbname);
        $database = $this->client->selectDB(parent::$dbname);

        $database->query("drop measurement $id");
    }

    public function update($id = null) {}
}