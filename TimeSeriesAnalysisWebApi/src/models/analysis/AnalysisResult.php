<?php
namespace TimeSeriesAnalysisWebApi\models\analysis;

use JsonSerializable;
use TimeSeriesAnalysisWebApi\models\analysis\transformation\TransformationType;

abstract class AnalysisResult implements JsonSerializable  {
    /** @var string */
    private $timeSeriesId;

    /** @var TransformationType */
    private $transformationType;

    private $type;
    private $result;

    public function __construct($timeSeriesId, $transformationType, $type, $result) {
        $this->timeSeriesId = $timeSeriesId;
        $this->transformationType = $transformationType;
        $this->type = $type;
        $this->result = $result;
    }

    public function getTimeSeriesId() {
        return $this->timeSeriesId;
    }

    public function getTransformationType() {
        return $this->transformationType;
    }

    public function getType() {
        return $this->type;
    }

    public function getResult() {
        return $this->result;
    }
}