<?php
namespace TimeSeriesAnalysisWebApi\libs\analysis;

use TimeSeriesAnalysisWebApi\libs\utils\Config;

class TimeSeriesAnalysis {
    public function __construct() {
    }

    private function getRScript($script) {
        return new RScript(Config::getInstance()->get("rscript", "r_script_path") . $script);
    }

    public function getTimeSeries($timeSeriesId) {
        $rScript = $this->getRScript("getTimeSeries.R");
        return $rScript->run(2, array("id" => "'" . $timeSeriesId . "'"));
    }

    public function getComplexityMeasures() {
        $rScript = $this->getRScript("getComplexityMeasures.R");

        $complexityMeasures = $rScript->run(1);

        return $complexityMeasures;
    }

    public function getForecastMethods() {
        $rScript = $this->getRScript("getForecastMethods.R");

        $forecastMethods = $rScript->run(1);

        return $forecastMethods;
    }

    public function getTransformations() {
        $rScript = $this->getRScript("getTransformations.R");

        $transformationsObject = $rScript->run(1);

        return $transformationsObject;
    }

    public function applyTransformation($timeSeriesId, $transformation) {
        $rScript = $this->getRScript("applyTransformation.R");
        $parameters = array("id" => "'" . $timeSeriesId . "'",
            "transformation" => "'" . $transformation["id"][0] . "'");

        $transformationData = $rScript->run(3, $parameters);

        return array(
            "id" => $timeSeriesId,
            "data" => array(
                "values" => $transformationData
            ),
            "timeSeriesTransformationType" => $transformation,
        );
    }

    public function applyComplexityMeasure($timeSeriesId, $complexityMeasure, $transformation) {
        $rScript = $this->getRScript("applyComplexityMeasure.R");
        $parameters = array("id" => "'" . $timeSeriesId . "'",
            "complexityMeasure" => "'" . $complexityMeasure["id"][0] . "'",
            "transformation" => "'" . $transformation["id"] . "'");

        $result = $rScript->run(4, $parameters);
        $result = $result["complexityMeasureResult"][0];

        return array(
            "id" => $timeSeriesId,
            "timeSeriesComplexityMeasureType" => $complexityMeasure,
            "timeSeriesTransformationType" => $transformation,
            "complexity" => $result
        );
    }

    public function applyForecast($timeSeriesId, $forecastMethod, $transformation, $percentTrain) {
        $rScript = $this->getRScript("applyForecast.R");
        $parameters = array("id" => "'" . $timeSeriesId . "'",
            "forecastMethod" => "'" . $forecastMethod["id"][0] . "'",
            "transformation" => "'" . $transformation["id"] . "'",
            "percentTrain" => $percentTrain);

        $result = $rScript->run(5, $parameters);

        return array(
            "id" => $timeSeriesId,
            "data" => array(
                "values" => $result
            ),
            "timeSeriesPredictMethod" => $forecastMethod,
            "timeSeriesTransformationType" => $transformation
        );
    }

    public function classification($timeSeriesId, $transformation) {
        $rScript = $this->getRScript("classification.R");
        $parameters = array("id" => "'" . $timeSeriesId . "'",
            "transformation" => "'" . $transformation["id"] . "'");

        $result = $rScript->run(3, $parameters);

        return array(
            "id" => $timeSeriesId,
            "timeSeriesTransformationType" => $transformation,
            "classification" => $result["center"][0],
            "forecastingMethod" => $result["method"][0]
        );
    }
}
