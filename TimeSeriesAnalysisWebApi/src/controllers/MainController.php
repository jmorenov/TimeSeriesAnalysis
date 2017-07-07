<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;

class MainController extends ApplicationController {
    public function __construct() {
        parent::__construct('[/]');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('GET', '', [MainController::class, 'getRoot']);
    }

    public static function getRoot(Request $request, Response $response) {
        $response->write('Time Series Analysis API');
    }
}

new MainController();