<?php
namespace TimeSeriesAnalysisWebApi\models\analysis;

abstract class AnalysisType {
    /** @var string */
    private $id;

    /** @var array */
    private $parameters;

    public function __construct($id, $parameters) {
        $this->id = $id;
        $this->parameters = $parameters;
    }

    public function getId() {
        return $this->id;
    }

    public function getParameters() {
        return $this->parameters;
    }
}