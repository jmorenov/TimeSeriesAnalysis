<?php
namespace TimeSeriesAnalysisWebApi\libs\utils;

use JsonSerializable;
use Exception;
use \TimeSeriesAnalysisWebApi\models\TimeSeriesData;

class FileReader implements JsonSerializable {
    private $error;
    private $name;
    private $type;
    private $path;
    private $size;
    private $data;

	public function __construct($file) {
        $this->error = $this->checkArrayArgument($file, 'error');
        $this->type = $this->checkArrayArgument($file, 'type');
        $this->path = $this->checkArrayArgument($file, 'tmp_name');
        $this->size = $this->checkArrayArgument($file, 'size');
        $this->name = $this->checkArrayArgument($file, 'name');

        $this->read_file();
    }
	
    private function csv_to_array() {
        $delimiter = $this->getDelimiter($this->path);
        $fileRows = fopen($this->path, "r");
        $this->data = $this->getArrayFromRows($fileRows, $delimiter);
    }

	private function read_file() {
        $this->csv_to_array();
    }
	
    private function getArrayFromRows($fileRows, $delimiter) {
        if ($fileRows === FALSE) {
            throw new Exception('File empty');
        }

        $fileArray = array();
        $headerRow = NULL;

        while (($fileRow = fgetcsv($fileRows, 0, $delimiter)) !== FALSE) {

            if ($headerRow == NULL) {
                $headerRow = $this->getHeader($fileRow);
                if ($headerRow != $fileRow) {
                    $fileArray[] = array_combine($headerRow, $fileRow);
                }
            }
            else if($fileRow[0] != null) {
                $fileArray[] = array_combine($headerRow, $fileRow);
            }
        }

        fclose($fileRows);

        return $fileArray;
    }

    private function getHeader($row) {
        $headerRowFormatted = array();
        $notHeader = false;
        foreach ($row as $rowElementIndex => $rowElement) {
            if (!is_string($rowElement) || is_numeric($rowElement)) {
                $notHeader = true;
            }
            $headerRowFormatted[] = 'Value ' . $rowElementIndex;
        }

        return $notHeader ? $headerRowFormatted : $row;
    }

    private function getDelimiter($filePath) {
        $fileString = file_get_contents($filePath);
        $countSemicolon = substr_count($fileString, ";");
        $countComma = substr_count($fileString, ",");

        return $countSemicolon >= $countComma ? ';' : ',';
    }

    private function checkArrayArgument($array, $argument) {
        if (isset($array[$argument])) {
            if (!is_string($array[$argument]) && isset($array[$argument][0])) {
                return $array[$argument][0];
            } else {
                return $array[$argument];
            }
        } else {
            return '';
        }
    }

    public function getData() {
        return $this->data;
    }

    private function getDates($timezone, $format) {
        $dates = array();

        for($i = 0; $i < count($this->getData()); $i++) {
            $dataRow = $this->getData()[$i];
            $valueDate = array_values($dataRow)[0];
            $dates[] = $valueDate;
        }

        if ($format == null) {
            $format = Date::getFormatOfArray($dates, $timezone);
        }

        for($i = 0; $i < count($dates); $i++) {
            $dates[$i] = new Date($dates[$i], $format, $timezone);
        }

        return $dates;
    }

    public function toTimeSeriesData($timezone, $withDates = true, $datesFormat = null) {
        $colnames = array_keys($this->getData()[0]);
        $dates = $withDates ? $this->getDates($timezone, $datesFormat) : array();
        $measures = [];

        for($i = 0; $i < count($this->getData()); $i++) {
            $m = [];
            $firstColumn = true;

            foreach($this->getData()[$i] as $key=>$value) {
                if (!$firstColumn || ($firstColumn && empty($dates))) {
                    $m[] = $value;
                }

                $firstColumn = false;
            }
            $measures[] = $m;
        }

        if (!empty($dates)) {
            unset($colnames[0]);

            $colnames = array_values($colnames);
        }

        return new TimeSeriesData($measures, $dates, array(), $colnames);
    }

    public function jsonSerialize() {

        return [
            'name' => $this->name,
            'error' => $this->error,
            'type' => $this->type,
            'path' => $this->path,
            'size' => $this->size,
            'data' => $this->data
        ];
    }
}
