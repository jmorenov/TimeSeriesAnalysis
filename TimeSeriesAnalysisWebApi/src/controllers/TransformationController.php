<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use \Exception;
use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;
use \TimeSeriesAnalysisWebApi\libs\analysis\TimeSeriesAnalysis;

class TransformationController extends ApplicationController {
    public function __construct() {
        parent::__construct('/analysis/transformation');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('GET', '[/]', [TransformationController::class, 'get']);
        $this->defineHttpMethod('POST', '[/]', [TransformationController::class, 'apply']);
    }

    public static function get(Request $request, Response $response) {
        try {
            $tsa = new TimeSeriesAnalysis();
            $result = $tsa->getTransformations();
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
            $transformation = $request->getParam('transformation');
            $tsa = new TimeSeriesAnalysis();
            $result = $tsa->applyTransformation($id, $transformation);

            return $response->write(json_encode($result));

        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }
}

new TransformationController();