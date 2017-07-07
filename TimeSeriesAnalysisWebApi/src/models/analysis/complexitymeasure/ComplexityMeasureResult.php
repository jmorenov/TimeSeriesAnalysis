<?php
namespace TimeSeriesAnalysisWebApi\models\analysis\complexitymeasure;

use TimeSeriesAnalysisWebApi\models\analysis\AnalysisResult;

class ComplexityMeasureResult extends AnalysisResult {
    public function __construct($timeSeriesId, $tranformationType, $type, $result) {
        parent::__construct($timeSeriesId, $tranformationType, $type, $result);
    }

    public function jsonSerialize() {
        return array(
            "id" => $this->getTimeSeriesId(),
            "timeSeriesComplexityMeasureType" => $this->getType(),
            "timeSeriesTransformationType" => $this->getTransformationType(),
            "complexity" => $this->getResult()
        );
    }
}