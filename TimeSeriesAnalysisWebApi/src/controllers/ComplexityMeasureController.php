<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use Exception;
use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\analysis\TimeSeriesAnalysis;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;
use TimeSeriesAnalysisWebApi\libs\database\ComplexityMeasureDB;
use TimeSeriesAnalysisWebApi\libs\database\UserDB;

class ComplexityMeasureController extends ApplicationController {
    public function __construct() {
        parent::__construct('/analysis/complexitymeasure');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('GET', '[/]', [ComplexityMeasureController::class, 'get']);
        $this->defineHttpMethod('GET', 'results/{id}[/]', [ComplexityMeasureController::class, 'applyAll']);
        $this->defineHttpMethod('GET', 'results[/]', [ComplexityMeasureController::class, 'applyAllToAll']);
        $this->defineHttpMethod('POST', '[/]', [ComplexityMeasureController::class, 'apply']);
        $this->defineHttpMethod('POST', 'insert[/]', [ComplexityMeasureController::class, 'insertAll']);
    }

    public static function get(/** @noinspection PhpUnusedParameterInspection */ Request $request, Response $response) {
        try {
            $tsa = new TimeSeriesAnalysis();
            $result = $tsa->getComplexityMeasures();

            return $response->write(json_encode($result));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function apply(Request $request, Response $response) {
        try {
            $id = $request->getParam('id');
            $method = $request->getParam('method');
            $transformationParam = $request->getParam('transformation');
            $transformation = isset($transformationParam) ? $transformationParam : array('id' => '');
            $tsa = new TimeSeriesAnalysis();
            $result = $tsa->applyComplexityMeasure($id, $method, $transformation);

            return $response->write(json_encode($result));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function applyAll(/** @noinspection PhpUnusedParameterInspection */ Request $request, Response $response, $args) {
        try {
            $result = ComplexityMeasureDB::getInstance()->get($args['id']);

            return $response->write(json_encode($result));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function applyAllToAll(/** @noinspection PhpUnusedParameterInspection */ Request $request, Response $response, $args) {
        try {
            $from = $request->getParam('from');
            $to = $request->getParam('to');

            $result = ComplexityMeasureDB::getInstance()->get(null, null, $from, $to);

            return $response->write(json_encode($result));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function insertAll(Request $request, Response $response) {
        try {
            $username = $request->getParam('username');
            $password = urldecode($request->getParam('password'));
            $isAuth = UserDB::getInstance()->login($username, $password);

            if (!$isAuth) {
                throw new Exception('User without access.');
            }

            $timeSeriesIds = json_decode($request->getParam('timeSeries'));
            $complexityMeasures = json_decode($request->getParam('complexityMeasures'));
            $results = json_decode($request->getParam('results'));

            $complexityMeasuresInserted =
                ComplexityMeasureDB::getInstance()->insert($timeSeriesIds, $complexityMeasures, $results);

            return $response->write(json_encode($complexityMeasuresInserted));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }
}

new ComplexityMeasureController();