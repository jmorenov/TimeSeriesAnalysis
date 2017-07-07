<?php
namespace TimeSeriesAnalysisWebApi\Test\controllers;

use \Slim\Http\Environment;
use \Slim\Http\Request;
use TimeSeriesAnalysisWebApi\libs\application\Application;

class MainControllerTest extends \PHPUnit_Framework_TestCase {
    protected $app;

    public function setUp()
    {
        $this->app = Application::getInstance();

        $env = Environment::mock([
            'REQUEST_METHOD' => 'GET',
            'REQUEST_URI'    => '/',
        ]);
        $request = Request::createFromGlobals((array) $env);

        $this->app->getContainer()['request'] = $request;
    }

    /**
     * @test
     */
    public function Should_Write_The_Correct_HTML_Text() {
        $response = $this->app->run(true);

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertEquals('Time Series Analysis API', (string)$response->getBody());
    }
}