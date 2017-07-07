<?php
namespace TimeSeriesAnalysisWebApi\models;

use JsonSerializable;
use stdClass;
use \TimeSeriesAnalysisWebApi\libs\utils\FileReader;
use \TimeSeriesAnalysisWebApi\libs\utils\Config;

class TimeSeriesUpload implements JsonSerializable {
    /** @var string */
    private $id;

    /** @var FileReader */
    private $file;

    /** @var string */
    private $datesFormat;

    /** @var bool */
    private $withDates;

    /** @var array */
    private $parameters;

    /** @var TimeSeriesData */
    private $timeSeriesData;

    public function __construct(stdClass $timeSeriesUploadStdObject) {
        $this->setParameters($timeSeriesUploadStdObject);

        $this->id = $this->formatParameter($timeSeriesUploadStdObject->id);
        $this->file = new FileReader($timeSeriesUploadStdObject->file);
        $this->datesFormat = isset($timeSeriesUploadStdObject->datesFormat) ? $this->formatParameter($timeSeriesUploadStdObject->datesFormat) : null;
        $this->withDates = $this->formatParameter($timeSeriesUploadStdObject->withDates);
        $this->timeSeriesData =
            $this->file->toTimeSeriesData($this->parameters['timezone'], $this->withDates, $this->datesFormat);
    }

    private function setParameters(stdClass $timeSeriesUploadStdObject) {
        $this->parameters = [
            'description' => isset($timeSeriesUploadStdObject->description) ? $this->formatParameter($timeSeriesUploadStdObject->description) : '',
            'reference_url' => isset($timeSeriesUploadStdObject->referenceUrl) ? $this->formatParameter($timeSeriesUploadStdObject->referenceUrl) : '',
            'timezone' => isset($timeSeriesUploadStdObject->timezone)
            && $this->checkParameter($timeSeriesUploadStdObject->timezone)
                ? $this->formatParameter($timeSeriesUploadStdObject->timezone) : Config::getInstance()->get('main', 'default_timezone'),
            'public' => isset($timeSeriesUploadStdObject->public) ? (int) $this->formatParameter($timeSeriesUploadStdObject->public) : 1,
            'username' => $this->formatParameter($timeSeriesUploadStdObject->username)
        ];
    }

    private function checkParameter($parameter) {
        if ($parameter == null || $parameter == '' || $parameter == false) {
            return false;
        }

        return true;
    }

    private function formatParameter($parameter) {
        if (is_array($parameter)) {
            return $parameter[0];
        }

        return $parameter;
    }

    public function getId() {
        return $this->id;
    }

    public function getTimeSeriesData() {
        return $this->timeSeriesData;
    }

    public function getParameters() {
        return $this->parameters;
    }

    public function getTimeSeries() {
        return new TimeSeries($this->getId(), $this->getParameters(), $this->getTimeSeriesData());
    }

    public function jsonSerialize() {
        return $this->getTimeSeries()->jsonSerialize();
    }
}