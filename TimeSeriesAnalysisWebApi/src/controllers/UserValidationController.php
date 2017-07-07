<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use \Exception;
use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;
use \TimeSeriesAnalysisWebApi\libs\database\UserDB;

class UserValidationController extends ApplicationController {
    public function __construct() {
        parent::__construct('/validation/user');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('GET', '/username/[{username}]', [UserValidationController::class, 'validateUsername']);
        $this->defineHttpMethod('GET', '/email/[{email}]', [UserValidationController::class, 'validateEmail']);
    }

    public static function validateUsername(Request $request, Response $response, $args) {
        try {
            $valid = UserDB::getInstance()->validateUsername($args['username']);
            return $response->write(json_encode($valid));
        } catch (Exception $ex) {
            return $response->write(json_encode(false));
        }
    }

    public static function validateEmail(Request $request, Response $response, $args) {
        try {
            $valid = UserDB::getInstance()->validateEmail($args['email']);
            return $response->write(json_encode($valid));
        } catch (Exception $ex) {
            return $response->write(json_encode(false));
        }
    }
}

new UserValidationController();