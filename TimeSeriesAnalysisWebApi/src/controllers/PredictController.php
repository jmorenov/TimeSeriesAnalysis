<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use Exception;
use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;
use TimeSeriesAnalysisWebApi\libs\analysis\TimeSeriesAnalysis;

class PredictController extends ApplicationController {
    public function __construct() {
        parent::__construct('/analysis/predict');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('GET', '[/]', [PredictController::class, 'get']);
        $this->defineHttpMethod('POST', '[/]', [PredictController::class, 'apply']);
    }

    public static function get(Request $request, Response $response) {
        try {
            $tsa = new TimeSeriesAnalysis();
            $result = $tsa->getForecastMethods();

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
            $percentTrain = isset($method['parameters']) && $method['parameters'] <= 1 ? $method['parameters'] : 0.8;
            $tsa = new TimeSeriesAnalysis();
            $result = $tsa->applyForecast($id, $method, $transformation, $percentTrain);

            return $response->write(json_encode($result));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }
}

new PredictController();