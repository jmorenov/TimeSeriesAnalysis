<?php
namespace TimeSeriesAnalysisWebApi\Test\models;

use PHPUnit\Framework\TestCase;
use TimeSeriesAnalysisWebApi\models\TimeSeries;

class TimeSeriesTest extends TestCase  {
    /**
     * @test
     */
    public function Should_Construct_The_Time_Series_Correctly_Without_Parameters_And_Data() {
        $timeSeries = new TimeSeries("TestID", array('username' => 'admin'));

        $this->assertEquals("TestID", $timeSeries->getID());
    }
}