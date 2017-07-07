<?php
namespace TimeSeriesAnalysisWebApi\models\analysis\transformation;

use TimeSeriesAnalysisWebApi\models\analysis\AnalysisType;

final class TransformationType extends AnalysisType {
    public function __construct($id, $parameters) {
        parent::__construct($id, $parameters);
    }
}