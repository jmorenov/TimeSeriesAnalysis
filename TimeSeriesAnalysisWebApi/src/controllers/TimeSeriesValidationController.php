<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use \Exception;
use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;
use \TimeSeriesAnalysisWebApi\libs\database\TimeSeriesDB;

class TimeSeriesValidationController extends ApplicationController {
    public function __construct() {
        parent::__construct('/validation/timeseries');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('GET', '/{id}[/]', [TimeSeriesValidationController::class, 'validate']);
    }

    public static function validate(Request $request, Response $response, $args) {
        try {
            $valid = TimeSeriesDB::getInstance()->validateTimeSeries($args['id']);
            return $response->write(json_encode($valid));
        } catch (Exception $ex) {
            return $response->write(json_encode(false));
        }
    }
}

new TimeSeriesValidationController();