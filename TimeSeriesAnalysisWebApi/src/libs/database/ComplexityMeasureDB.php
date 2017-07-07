<?php
namespace TimeSeriesAnalysisWebApi\libs\database;

use Exception;
use TimeSeriesAnalysisWebApi\libs\utils\Config;
use TimeSeriesAnalysisWebApi\models\analysis\complexitymeasure\ComplexityMeasureResult;

final class ComplexityMeasureDB extends Database {
    /** @var ComplexityMeasureDB */
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

    public function get($timeSeriesId = null, $complexityMeasureTypeId = null, $from = null, $to = null) {
        $this->query = "SELECT * from complexity_measures ";

        if ($timeSeriesId != null) {
            $this->query .= "WHERE timeseries_id = '$timeSeriesId'";
        }

        if ($from != null && $to != null && $from <= $to) {
            $limit = $to - $from + 1;

            $offset = $from - 1;

            $this->query .= "LIMIT " . $limit . " OFFSET " . $offset;
        } else {
            $this->query .= "LIMIT 100";
        }

        $error = $this->get_results_from_query();

        if(is_string($error) && $error != '') {
            throw new Exception('"Error applying complexity measures: ' . $error);
        }

        if (count($this->rows) > 0) {
            $result = [];
            foreach ($this->rows as $row) {
                $complexityMeasures = json_decode($row['results']);
                $complexityMeasuresResults = array();

                foreach ($complexityMeasures as $complexityMeasure) {
                    if ($complexityMeasureTypeId == null || $complexityMeasureTypeId == $complexityMeasure['timeSeriesComplexityMeasureType']['id']) {
                        $complexityMeasuresResults[]
                            = new ComplexityMeasureResult(
                            $row['timeseries_id'],
                            $complexityMeasure->timeSeriesTransformationType,
                            $complexityMeasure->timeSeriesComplexityMeasureType,
                            $complexityMeasure->complexity);
                    }
                }

                $result[] = $complexityMeasuresResults;
            }

            return $result;
        }

        return false;
    }

    public function insert($timeSeriesIds = null, $complexityMeasures = null, $results = null, $forceInsert = false) {
        if ($timeSeriesIds == null || $complexityMeasures == null || $results == null) {
            throw new Exception("Error inserting complexity measures: missing fields.");
        }

        if (count($timeSeriesIds) != count($results)) {
            throw new Exception("Error inserting complexity measures: invalid data.");
        }

        for ($i = 0; $i < count($timeSeriesIds); $i++) {
            $timeSeriesId = $timeSeriesIds[$i];

            if ($forceInsert || !$this->get($timeSeriesId)) {
                $complexityMeasuresResults = array();
                $timeSeriesResults = $results[$i];

                if (count($timeSeriesResults) != count($complexityMeasures)) {
                    throw new Exception("Error inserting complexity measures: invalid data.");
                }

                for ($j = 0; $j < count($timeSeriesResults); $j++) {
                    $complexityMeasuresResults[]
                        = new ComplexityMeasureResult(
                        $timeSeriesId,
                        null,
                        $complexityMeasures[$j],
                        $timeSeriesResults[$j]);
                }
                $resultsEncoded = json_encode($complexityMeasuresResults);
                $this->query = "INSERT INTO complexity_measures (timeseries_id, results) VALUES('$timeSeriesId', '$resultsEncoded')";
                $error = $this->execute_single_query();

                if(is_string($error) && $error != '') {
                    throw new Exception('Error inserting complexity measures: ' . $error);
                }
            }
        }

        return true;
    }

    public function delete() {

    }

    public function update() {

    }
}