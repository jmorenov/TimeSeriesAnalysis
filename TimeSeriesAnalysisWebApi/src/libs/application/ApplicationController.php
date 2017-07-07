<?php
namespace TimeSeriesAnalysisWebApi\libs\application;

abstract class ApplicationController {
    protected $app;
    private $controllerPattern;

    public function __construct($controllerPattern) {
        $this->app = Application::getInstance();
        $this->controllerPattern = $controllerPattern;

        $this->defineHttpMethods();
    }

    public function defineHttpMethod($httpMethod, $pattern, callable $callback) {
        $this->app->defineHttpMethod($httpMethod, $this->controllerPattern . $pattern, $callback);
    }

    abstract protected function defineHttpMethods();
}