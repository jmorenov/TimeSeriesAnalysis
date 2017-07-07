<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use \Exception;
use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;
use \TimeSeriesAnalysisWebApi\libs\database\UserDB;
use \TimeSeriesAnalysisWebApi\models\User;

class UserController extends ApplicationController {
    public function __construct() {
        parent::__construct('/users');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('GET', '/{username}[/]', [UserController::class, 'get']);
        $this->defineHttpMethod('GET', '[/]', [UserController::class, 'getAll']);
        $this->defineHttpMethod('POST', '[/]', [UserController::class, 'create']);
        $this->defineHttpMethod('PUT', '[/]', [UserController::class, 'update']);
    }

    public static function get(Request $request, Response $response, $args) {
        try {
            $authToken = $request->getParam('token');
            $isLogged = UserDB::getInstance()->authUser($args['username'], $authToken);

            if (!$isLogged) {
                throw new Exception('User without access.');
            }

            $user = UserDB::getInstance()->get($args['username'], '', true);

            return responseJSON($response, $user);
        } catch (Exception $ex) {
            return responseJSON($response, array(
                'error' => $ex->getMessage()
            ));
        }
    }

    public static function getAll(Request $request, Response $response) {
        try {
            $usdb = UserDB::getInstance();
            $userList = $usdb->get();

            return responseJSON($response, $userList);
        } catch (Exception $ex) {
            return responseJSON($response, array(
                'error' => $ex->getMessage()
            ));
        }
    }

    public static function create(Request $request, Response $response) {
        try {
            $user = new User($request->getParam('user'));
            $password = $request->getParam('password');
            $userResult = UserDB::getInstance()->insert($user, $password);

            return responseJSON($response, $userResult);
        } catch (Exception $ex) {
            return responseJSON($response, array(
                'error' => $ex->getMessage()
            ));
        }
    }

    public static function update(Request $request, Response $response) {
        try {
            $updatedUser = new User($request->getParam('user'));
            $updatedPassword = $request->getParam('password');
            $isLogged = UserDB::getInstance()->authUser($updatedUser->getUsername(), $updatedUser->getAuthToken());

            if (!$isLogged) {
                throw new Exception('User without access.');
            }

            $userResult = UserDB::getInstance()->update($updatedUser, $updatedPassword);

            return responseJSON($response, $userResult);
        } catch (Exception $ex) {
            return responseJSON($response, array(
                'error' => $ex->getMessage()
            ));
        }
    }
}

new UserController();