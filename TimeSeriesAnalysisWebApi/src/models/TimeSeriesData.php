<?php
namespace TimeSeriesAnalysisWebApi\models;

use JsonSerializable;
use Exception;
use TimeSeriesAnalysisWebApi\libs\utils\Config;
use \TimeSeriesAnalysisWebApi\libs\utils\Date;

class TimeSeriesData implements JsonSerializable {

    /** @var array */
    private $measures;

    /** @var Date[] */
    private $dates;

    /** @var array */
    private $rownames;

    /** @var array */
    private $colnames;
	
    public function __construct(array $measures, array $dates = array(), array $rownames = array(), array $colnames = array()) {
        $this->setMeasures($measures);

        if (empty($rownames)) {
            $rownames = array_keys($this->measures);
        }

        $this->setRownames($rownames);

        if (empty($colnames)) {
            $colnames = array_keys($this->measures[0]);
        }

        $this->setColnames($colnames);

        if (!empty($dates)) {
            $this->setDates($dates);
        } else {
            $this->setDatesNow();
        }
    }

    public function setMeasures(array $measures) {
        if (empty($measures)) {
            throw new Exception('Error creating TimeSeriesData: Empty measures');
        }

        for ($i = 1; $i < count($measures); $i++) {
            if (empty($measures[$i - 1]) || empty($measures[$i]) || count($measures[$i - 1]) != count($measures[$i])) {
                throw new Exception('Error creating TimeSeriesData: Error on measures');
            }
        }

        $this->measures = $measures;
    }

    public function setDatesNow() {
        $defaulTimezone = Config::getInstance()->get("main", "default_timezone");
        $timestamp = array_fill(0, $this->nvalues(), 0);
        $timestamp[$this->nvalues() - 1] = new Date(time(), Date::$timestamp_format, $defaulTimezone);

        for ($i = $this->nvalues() - 2; $i >= 0; $i--) {
            /** @var $timestamp Date[] */
            $timestamp[$i] = new Date($timestamp[$i + 1]->getTimestamp() - 100, Date::$timestamp_format, $defaulTimezone);
        }

        $this->setDates($timestamp);
    }

    public function setDates(array $dates) {
        if (empty($dates) || $this->nvalues() != count($dates)) {
            throw new Exception('Error creating TimeSeriesData: Empty dates');
        }

        $_dates = [];

        foreach ($dates as $date) {
            if (get_class($date) == 'TimeSeriesAnalysisWebApi\\libs\\utils\\Date') {
                $_dates[] = $date->getTimestamp();
            } else {
                throw new Exception('Error creating TimeSeriesData: Error on dates');
            }
        }

        $_dates = $this->sortDates($_dates);

        for ($i = 0; $i < count($_dates); $i++) {
            $_dates[$i] = new Date($_dates[$i], Date::$timestamp_format, Config::getInstance()->get("main", "default_timezone"));
        }

        $this->dates = $_dates;
    }

    private function sortDates(array $dates) {
        asort($dates);

        $measures = [];
        $index = 0;

        foreach($dates as $key=>$date) {
            $measures[$index] = $this->getMeasures($key);

            $index++;
        }

        $this->setMeasures($measures);

        $dates = array_values($dates);

        return $dates;
    }

    public function setRownames(array $rownames) {
        if ($this->nvalues() != count($rownames)) {
            throw new Exception('Error creatint: TimeSeriesData: Error on number of values');
        }
        $this->rownames = $rownames;
    }

    public function setColnames(array $colnames) {
        if ($this->nvars() != count($colnames)) {
            throw new Exception('Error creatint: TimeSeriesData: Error on number of variables');
        }
        $this->colnames = $colnames;
    }

    public function nvalues() {
        return count($this->measures);
    }

    public function nvars() {
        return count($this->measures[0]);
    }

    public function getDates() {
        return $this->dates;
    }

    public function getDate($i) {
        return $this->dates[$i];
    }

    public function getMeasure($i, $j) {
        return $this->getMeasures($i)[$j];
    }

    public function getMeasures($i) {
        return $this->measures[$i];
    }

    public function getRownames() {
        return $this->rownames;
    }

    public function getColnames() {
        return $this->colnames;
    }

    public function getTimestamp() {
        if ($this->getDates() == null) {
            throw new Exception('Error TimeSeriesData: missing dates when getting timestamp');
        }

        $timestamp = [];
        for ($i = 0; $i < $this->nvalues(); $i++) {
            $timestamp[] = $this->getDates()[$i]->getTimestamp();
        }
        return $timestamp;
    }

    public function getDataParameters() {
        $parameters = array();
        $max = $min = $this->getMeasure(0, 0);
        $maxDate = $minDate = $this->getDates()[0];
        $mean = 0;

        for ($i = 0; $i < $this->nvalues(); $i++) {
            for ($j=0; $j < $this->nvars(); $j++) {
                if ($max != null && $this->getMeasure($i, $j) > $max) {
                    $max = $this->getMeasure($i, $j);
                    $maxDate = $this->dates[$i];
                }

                if ($min != null && $this->getMeasure($i, $j) < $min) {
                    $min = $this->getMeasure($i, $j);
                    $minDate = $this->dates[$i];
                }

                $mean += $this->getMeasure($i, $j);
            }
        }

        $parameters["start"] = $this->getDates()[0];
        $parameters["end"] = $this->getDates()[$this->nvalues() - 1];
        $parameters["nvalues"] = $this->nvalues();
        $parameters["nvars"] = $this->nvars();
        $parameters["max"] = $max;
        $parameters["min"] = $min;
        $parameters["maxDate"] = $maxDate;
        $parameters["minDate"] = $minDate;
        $parameters["mean"] = $mean/$this->nvalues();
        $parameters["frequency"] = 1;

        return $parameters;
    }

    public function jsonSerialize() {
        return [
            'values' => $this->measures,
            'dates' => $this->dates
        ];
    }
}
