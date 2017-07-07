<?php
namespace TimeSeriesAnalysisWebApi\models\analysis\complexitymeasure;

use TimeSeriesAnalysisWebApi\models\analysis\AnalysisType;

final class ComplexityMeasureType extends AnalysisType {
    public function __construct($id, $parameters) {
        parent::__construct($id, $parameters);
    }
}