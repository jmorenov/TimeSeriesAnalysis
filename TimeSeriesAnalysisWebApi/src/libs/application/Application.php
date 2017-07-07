<?php
namespace TimeSeriesAnalysisWebApi\libs\application;

use \Slim\App;

class Application {
    private $app;
    private static $instance;

    private function __construct() {
        $this->app = new App();
    }

    public static function getInstance() {
        if (!self::$instance instanceof self) {
            self::$instance = new self;
        }
        return self::$instance;
    }

    public function defineHttpMethod($httpMethod, $pattern, callable $callback) {
        switch ($httpMethod) {
            case 'GET':
                $this->app->get($pattern, $callback);
                break;
            case 'POST':
                $this->app->post($pattern, $callback);
                break;
            case 'DELETE':
                $this->app->delete($pattern, $callback);
                break;
            case 'PUT':
                $this->app->put($pattern, $callback);
                break;
        }
    }

    public function getContainer() {
        return $this->app->getContainer();
    }

    public function run($silent = false) {
        return $this->app->run($silent);
    }
}