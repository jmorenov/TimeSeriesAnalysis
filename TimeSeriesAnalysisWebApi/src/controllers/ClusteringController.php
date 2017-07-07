<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use Exception;
use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;
use TimeSeriesAnalysisWebApi\libs\database\ClusteringDB;
use TimeSeriesAnalysisWebApi\libs\database\UserDB;

class ClusteringController extends ApplicationController {
    public function __construct() {
        parent::__construct('/analysis/clustering');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('GET', '[/]', [ClusteringController::class, 'get']);
        $this->defineHttpMethod('POST', '[/]', [ClusteringController::class, 'insert']);
    }

    public static function get(Request $request, Response $response) {
        try {
            $result = ClusteringDB::getInstance()->get();

            return $response->write(json_encode($result));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function insert(Request $request, Response $response) {
        try {
            $username = $request->getParam('username');
            $password = urldecode($request->getParam('password'));
            $isAuth = UserDB::getInstance()->login($username, $password);

            if (!$isAuth) {
                throw new Exception('User without access.');
            }

            $centers = json_decode($request->getParam('centers'));

            $result = ClusteringDB::getInstance()->insert($centers);

            return $response->write(json_encode($result));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }
}

new ClusteringController();