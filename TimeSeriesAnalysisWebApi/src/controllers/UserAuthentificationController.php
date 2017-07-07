<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use \Exception;
use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;
use \TimeSeriesAnalysisWebApi\libs\database\UserDB;

class UserAuthentificationController extends ApplicationController {
    public function __construct() {
        parent::__construct('/authentification');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('GET', '/{username}[/]', [UserAuthentificationController::class, 'authentificateUser']);
        $this->defineHttpMethod('POST', '[/]', [UserAuthentificationController::class, 'authentificateSession']);
    }

    public static function authentificateUser(Request $request, Response $response, $args) {
        try {
            $authToken = $request->getParam('token');
            $isLogged = UserDB::getInstance()->authUser($args['username'], $authToken);

            return $response->write(json_encode($isLogged));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function authentificateSession(Request $request, Response $response) {
        try {
            $username = $request->getParam('username');
            $password = $request->getParam('password');
            $userResult = UserDB::getInstance()->login($username, $password);

            return $response->write(json_encode($userResult));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }
}

new UserAuthentificationController();