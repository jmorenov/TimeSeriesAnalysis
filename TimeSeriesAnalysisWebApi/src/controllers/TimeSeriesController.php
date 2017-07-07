<?php
namespace TimeSeriesAnalysisWebApi\controllers;

use Exception;
use \Slim\Http\Request;
use \Slim\Http\Response;
use \TimeSeriesAnalysisWebApi\libs\database\TimeSeriesDB;
use \TimeSeriesAnalysisWebApi\libs\database\UserDB;
use \TimeSeriesAnalysisWebApi\models\TimeSeriesUpload;
use \TimeSeriesAnalysisWebApi\libs\application\ApplicationController;

class TimeSeriesController extends ApplicationController {
    public function __construct() {
        parent::__construct('/timeseries');
    }

    protected function defineHttpMethods() {
        $this->defineHttpMethod('GET', '[/]', [TimeSeriesController::class, 'getAll']);
        $this->defineHttpMethod('GET', 'ids[/]', [TimeSeriesController::class, 'getAllIds']);
        $this->defineHttpMethod('GET', 'count[/]', [TimeSeriesController::class, 'count']);
        $this->defineHttpMethod('GET', '/{id}[/]', [TimeSeriesController::class, 'getById']);
        $this->defineHttpMethod('GET', '/{id}/{username}[/]', [TimeSeriesController::class, 'getByIdAndUser']);
        $this->defineHttpMethod('GET', 'private/{username}[/]', [TimeSeriesController::class, 'getPrivatesOfUser']);
        $this->defineHttpMethod('POST', '[/]', [TimeSeriesController::class, 'upload']);
        $this->defineHttpMethod('DELETE', '/{id}[/]', [TimeSeriesController::class, 'delete']);
    }

    /**
     * @param Request $request [optional]
     * @param Response $response
     * @param array $args
     * @return \Slim\Http\Response
     */
    public static function getById(/** @noinspection PhpUnusedParameterInspection */ Request $request, Response $response, $args) {
        try {
            $tsdb = TimeSeriesDB::getInstance();
            $timeseries = $tsdb->get($args['id'], true);

            if ($timeseries && $timeseries->getParameter('public') == 0) {
                throw new Exception('User without access.');
            }

            return responseJSON($response, $timeseries);
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function getByIdAndUser(Request $request, Response $response, $args) {
        try {
            $authToken = $request->getParam('token');
            $isLogged = UserDB::getInstance()->authUser($args['username'], $authToken);
            $tsdb = TimeSeriesDB::getInstance();
            $timeseries = $tsdb->get($args['id'], true);

            if ($timeseries && $timeseries->getParameter('public') == 0) {
                if ($args['username'] != $timeseries->getParameter('username')
                    || ($args['username'] == $timeseries->getParameter('username') && !$isLogged)) {
                    throw new Exception('User without access.');
                }
            }

            return responseJSON($response, $timeseries);
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    /**
     * @param Request $request [optional]
     * @param Response $response
     * @return \Slim\Http\Response
     */
    public static function getAll(/** @noinspection PhpUnusedParameterInspection */ Request $request, Response $response) {
        try {
            $tsdb = TimeSeriesDB::getInstance();
            $timeserieslist = $tsdb->getPublic();

            return responseJSON($response, $timeserieslist);
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    /**
     * @param Request $request [optional]
     * @param Response $response
     * @return \Slim\Http\Response
     */
    public static function getAllIds(/** @noinspection PhpUnusedParameterInspection */ Request $request, Response $response) {
        try {
            $withNValuesParam = strtolower($request->getParam("withNValues"));
            $withNValues = $withNValuesParam == 'true' ? true : false;

            if ($withNValues == null) {
                $withNValues = false;
            }

            $maxNValues = (int) $request->getParam("maxNValues");

            $tsdb = TimeSeriesDB::getInstance();
            $timeseriesIdsList = $tsdb->getIds($withNValues, $maxNValues);

            return responseJSON($response, $timeseriesIdsList);
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function getPrivatesOfUser(Request $request, Response $response, $args) {
        try {
            $authToken = $request->getParam('token');
            $isLogged = UserDB::getInstance()->authUser($args['username'], $authToken);

            if (!$isLogged) {
                throw new Exception('User without access.');
            }

            $tsdb = TimeSeriesDB::getInstance();
            $timeserieslist = $tsdb->getFromUser($args['username']);

            return responseJSON($response, $timeserieslist);
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function upload(Request $request, Response $response) {
        try {
            $user = json_decode($request->getParam('user'));

            if ($user != null && isset($user->username) && isset($user->authToken)) {
                $username = $user->username;

                $isAuth = UserDB::getInstance()->authUser($username, $user->authToken);
            } else {
                $username = $request->getParam('username');
                $password = urldecode($request->getParam('password'));

                $isAuth = UserDB::getInstance()->login($username, $password);
            }

            if (!$isAuth) {
                throw new Exception('User without access.');
            }

            $timeseriesUploadStd = json_decode($request->getParam('timeseries'));

            if (!isset($timeseriesUploadStd)) {
                throw new Exception('Missing TimeSeries fields.');
            }

            if (isset($_FILES['timeseriesfile'])) {
                $timeseriesUploadStd->file = $_FILES['timeseriesfile'];
                $timeseriesUploadStd->username = $username;

                $timeseriesUpload = new TimeSeriesUpload($timeseriesUploadStd);

                $timeSeries = TimeSeriesDB::getInstance()->insert($timeseriesUpload->getTimeSeries());
            } else {
                throw new Exception('File not found.');
            }

            return responseJSON($response, array(
                'timeSeries' => $timeSeries
            ));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function delete(/** @noinspection PhpUnusedParameterInspection */ Request $request, Response $response, $args) {
        try {
            $id = $args['id'];
            $result = TimeSeriesDB::getInstance()->delete($id);

            return responseJSON($response, array(
                'result' => $result
            ));
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }

    public static function count(/** @noinspection PhpUnusedParameterInspection */ Request $request, Response $response) {
        try {
            $tsdb = TimeSeriesDB::getInstance();
            $timeseriesCount = $tsdb->count();

            return responseJSON($response, $timeseriesCount);
        } catch (Exception $ex) {
            return $response->write(json_encode(array(
                'error' => $ex->getMessage()
            )));
        }
    }
}

new TimeSeriesController();