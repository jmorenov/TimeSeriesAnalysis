<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use Exception;
use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;
use \TimeSeriesAnalysisWebApi\libs\analysis\TimeSeriesAnalysis;

class ClassifyController extends ApplicationController {
    public function __construct() {
        parent::__construct('/analysis/classify');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('POST', '[/]', [ClassifyController::class, 'classify']);
    }

    public static function classify(Request $request, Response $response) {
        try {
            $id = $request->getParam('id');
            $transformationParam = $request->getParam('transformation');
            $transformation = isset($transformationParam) ? $transformationParam : array('id' => '');
            $tsa = new TimeSeriesAnalysis();
            $result = $tsa->classification($id, $transformation);

            return $response->write(json_encode($result));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }
}

new ClassifyController();