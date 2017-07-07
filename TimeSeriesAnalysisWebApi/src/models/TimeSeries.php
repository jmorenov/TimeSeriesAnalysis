<?php
namespace TimeSeriesAnalysisWebApi\models;

use Exception;
use JsonSerializable;
use TimeSeriesAnalysisWebApi\libs\utils\Config;
use TimeSeriesAnalysisWebApi\libs\utils\Date;

class TimeSeries implements JsonSerializable {
    private $id;
    private $parameters_keys = ["public", "username", "description", "tags",
        "reference_url", "timezone",
        "start", "end", "frequency",
        "nvalues", "nvars", "mean", "max", "min", "maxDate", "minDate"];
    private $parameters;

    /** @var TimeSeriesData */
    private $data;

    public function __construct($id, array $parameters, TimeSeriesData $data = null) {
        $this->id = $id;
        $this->data = $data;

        $this->setParameters($parameters);
    }

    private function setParameters(array $parameters) {
        $this->checkParameters($parameters);

        if ($this->getData() != null && !$this->dataParametersCalculated($parameters)) {
            $parameters = array_merge($parameters, $this->getData()->getDataParameters());
        }

        foreach ($this->parameters_keys as $key) {
            if (array_key_exists($key, $parameters)) {
                if (($key == "maxDate" || $key == "minDate" || $key == 'start' || $key == 'end')
                    && $parameters[$key] != null) {
                    if (!is_string($parameters[$key]) && $parameters[$key] == 'TimeSeriesAnalysisWebApi\\libs\\utils\\Date') {
                        $this->parameters[$key] = $parameters[$key];
                    } else {
                        $this->parameters[$key] = new Date($parameters[$key], 'Y-m-d H:i:s', $parameters['timezone']);
                    }
                } else {
                    $this->parameters[$key] = $parameters[$key];
                }
            }
        }
    }

    private function checkParameters(array $parameters) {
        if (empty($parameters)) {
            throw new Exception('Error creating TimeSeries: Missing parameters');
        }

        if (!isset($parameters['timezone'])) {
            $parameters['timezone'] = Config::getInstance()->get('main', 'default_timezone');
        }

        if (!isset($parameters['username'])) {
            throw new Exception('Error creating TimeSeries: Missing parameter username');
        }
    }

    private function dataParametersCalculated(array $parameters) {
        $dataParametersKeys = ['start', 'end', 'nvalues', 'nvars', 'max', 'min',
            'maxDate', 'minDate', 'frequency', 'mean'];

        foreach ($dataParametersKeys as $dataParameterKey) {
            if (!isset($parameters[$dataParameterKey])
                || $parameters[$dataParameterKey] == null
                || $parameters[$dataParameterKey] == '') {
                return false;
            }
        }

        return true;
    }

    public function getID() {
        return $this->id;
    }

    public function getParameters() {
        return $this->parameters;
    }

    public function getParameter($name) {
        if (array_key_exists($name, $this->getParameters())) {
            return $this->getParameters()[$name];
        } else {
            return false;
        }
    }

    public function getData() {
        if ($this->data != null) {
            return $this->data;
        } else {
            return false;
        }
    }

    public function jsonSerialize() {
        return [
            'id' => $this->getID(),
            'username' => $this->getParameter('username'),
            'public' => $this->getParameter('public'),
            'data' => $this->getData(),
            'description' => $this->getParameter('description'),
            'referenceUrl' => $this->getParameter('reference_url'),
            'numberOfValues' => $this->getParameter('nvalues'),
            'numberOfVars' => $this->getParameter('nvars'),
            'timezone' => $this->getParameter('timezone'),
            'startDate' => $this->getParameter('start'),
            'endDate' => $this->getParameter('end'),
            'frequency' => $this->getParameter('frequency'),
            'mean' => $this->getParameter('mean'),
            'max' => $this->getParameter('max'),
            'min' => $this->getParameter('min'),
            'minDate' => $this->getParameter('minDate'),
            'maxDate' => $this->getParameter('maxDate')
        ];
    }
}