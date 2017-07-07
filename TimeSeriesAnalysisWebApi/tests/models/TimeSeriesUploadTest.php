<?php
namespace TimeSeriesAnalysisWebApi\Test\models;

use PHPUnit\Framework\TestCase;
use stdClass;
use TimeSeriesAnalysisWebApi\libs\utils\Date;
use TimeSeriesAnalysisWebApi\models\TimeSeriesUpload;

class TimeSeriesUploadTest extends TestCase {
    private $timeSeriesUploadStdObject;

    public function setUp()
    {
        $this->timeSeriesUploadStdObject = new stdClass();

        $this->timeSeriesUploadStdObject->file = array(
            'error' => 'error',
            'tmp_name' => GLOBAL_PATH . '/tests/data/FRED_4BIGEUROREC.csv',
            'size' => '1',
            'type' => 'csv',
            'name' => 'test file'
        );

        $this->timeSeriesUploadStdObject->id = 'test id';
        $this->timeSeriesUploadStdObject->withDates = true;
        $this->timeSeriesUploadStdObject->timezone = 'GMT';
        $this->timeSeriesUploadStdObject->description = 'description test';
        $this->timeSeriesUploadStdObject->referenceUrl = 'http://test';
        $this->timeSeriesUploadStdObject->public = '0';
        $this->timeSeriesUploadStdObject->username = 'admin';
    }

    /**
     * @test
     */
    public function Should_Construct_The_Time_Series_Upload_Correctly_With_Dates_And_Timezone_Defined() {
        $timeSeriesUpload = new TimeSeriesUpload($this->timeSeriesUploadStdObject);

        $this->assertEquals('test id', $timeSeriesUpload->getId());

        $this->assertEquals('GMT', $timeSeriesUpload->getParameters()['timezone']);
        $this->assertEquals('description test', $timeSeriesUpload->getParameters()['description']);
        $this->assertEquals('http://test', $timeSeriesUpload->getParameters()['reference_url']);
        $this->assertEquals('0', $timeSeriesUpload->getParameters()['public']);
        $this->assertEquals('admin', $timeSeriesUpload->getParameters()['username']);

        $timeSeriesData = clone($timeSeriesUpload->getTimeSeriesData());

        $this->assertEquals(629, $timeSeriesData->nvalues());
        $this->assertEquals(1, $timeSeriesData->nvars());
        $this->assertEquals(Array (0 => 'Value'), $timeSeriesData->getColnames());
        $this->assertEquals([25], $timeSeriesData->getMeasures(628));

        $firstDate = $timeSeriesData->getDate(0);
        $this->assertEquals('1962-05-01', $firstDate->getDate('Y-m-d'));

        $lastDate = $timeSeriesData->getDate($timeSeriesData->nvalues() - 1);
        $this->assertEquals('2014-09-01', $lastDate->getDate('Y-m-d'));

        $timeSeries = clone($timeSeriesUpload->getTimeSeries());

        $this->assertEquals('test id', $timeSeries->getID());
        $this->assertEquals($timeSeriesData, $timeSeries->getData());
        $this->assertEquals('0', $timeSeries->getParameter('public'));
        $this->assertEquals('admin', $timeSeries->getParameter('username'));
        $this->assertEquals('description test', $timeSeries->getParameter('description'));
        $this->assertEquals('http://test', $timeSeries->getParameter('reference_url'));
        $this->assertEquals('GMT', $timeSeries->getParameter('timezone'));
        $this->assertEquals('1', $timeSeries->getParameter('frequency'));
        $this->assertEquals(629, $timeSeries->getParameter('nvalues'));
        $this->assertEquals(1, $timeSeries->getParameter('nvars'));
        $this->assertEquals(0.53100158982512, $timeSeries->getParameter('mean'));
        $this->assertEquals(36, $timeSeries->getParameter('max'));
        $this->assertEquals(0, $timeSeries->getParameter('min'));

        $startDate = $timeSeries->getParameter('start');
        $endDate = $timeSeries->getParameter('end');
        /** @var $startDate Date */
        /** @var $endDate Date */
        $this->assertEquals('1962-05-01', $startDate->getDate('Y-m-d'));
        $this->assertEquals('2014-09-01', $endDate->getDate('Y-m-d'));

        $maxDate = $timeSeries->getParameter('maxDate');
        $minDate = $timeSeries->getParameter('minDate');
        /** @var $maxDate Date */
        /** @var $minDate Date */
        $this->assertEquals('2014-08-01', $maxDate->getDate('Y-m-d'));
        $this->assertEquals('1962-05-01', $minDate->getDate('Y-m-d'));
    }

    /**
     * @test
     */
    public function Should_Construct_The_Time_Series_Upload_Correctly_With_Dates_And_Timezone_Undefined() {
        $this->timeSeriesUploadStdObject->timezone = '';
        $this->timeSeriesUploadStdObject->withDates = false;
        $timeSeriesUpload = new TimeSeriesUpload($this->timeSeriesUploadStdObject);

        $timeSeries = clone($timeSeriesUpload->getTimeSeries());

        $this->assertEquals('UTC', $timeSeries->getParameter('timezone'));
    }

    /**
     * @test
     */
    public function Should_Construct_The_Time_Series_Upload_Correctly_Without_Header_And_Without_Dates() {
        $this->timeSeriesUploadStdObject->file['tmp_name'] =
            GLOBAL_PATH . '/tests/data/TimeSeriesWithoutHeaderAndWithoutDates.csv';
        $this->timeSeriesUploadStdObject->withDates = false;
        $timeSeriesUpload = new TimeSeriesUpload($this->timeSeriesUploadStdObject);

        $this->assertEquals('test id', $timeSeriesUpload->getId());

        $this->assertEquals('GMT', $timeSeriesUpload->getParameters()['timezone']);
        $this->assertEquals('description test', $timeSeriesUpload->getParameters()['description']);
        $this->assertEquals('http://test', $timeSeriesUpload->getParameters()['reference_url']);
        $this->assertEquals('0', $timeSeriesUpload->getParameters()['public']);
        $this->assertEquals('admin', $timeSeriesUpload->getParameters()['username']);

        $timeSeriesData = clone($timeSeriesUpload->getTimeSeriesData());

        $this->assertEquals(8, $timeSeriesData->nvalues());
        $this->assertEquals(1, $timeSeriesData->nvars());
        $this->assertEquals(Array (0 => 'Value 0'), $timeSeriesData->getColnames());
        $this->assertEquals([23], $timeSeriesData->getMeasures(0));
        $this->assertEquals([30], $timeSeriesData->getMeasures(7));

        $today = (new Date(time(), Date::$timestamp_format, 'GMT'))->getDate('Y-m-d');
        $firstDate = $timeSeriesData->getDate(0);
        $this->assertEquals($today, $firstDate->getDate('Y-m-d'));

        $lastDate = $timeSeriesData->getDate($timeSeriesData->nvalues() - 1);
        $this->assertEquals($today, $lastDate->getDate('Y-m-d'));

        $timeSeries = clone($timeSeriesUpload->getTimeSeries());

        $this->assertEquals($timeSeriesData, $timeSeries->getData());

        $this->assertEquals('test id', $timeSeries->getID());
        $this->assertEquals($timeSeriesData, $timeSeries->getData());
        $this->assertEquals('0', $timeSeries->getParameter('public'));
        $this->assertEquals('admin', $timeSeries->getParameter('username'));
        $this->assertEquals('description test', $timeSeries->getParameter('description'));
        $this->assertEquals('http://test', $timeSeries->getParameter('reference_url'));
        $this->assertEquals('GMT', $timeSeries->getParameter('timezone'));
        $this->assertEquals('1', $timeSeries->getParameter('frequency'));
        $this->assertEquals(8, $timeSeries->getParameter('nvalues'));
        $this->assertEquals(1, $timeSeries->getParameter('nvars'));
        $this->assertEquals(26.5, $timeSeries->getParameter('mean'));
        $this->assertEquals(30, $timeSeries->getParameter('max'));
        $this->assertEquals(23, $timeSeries->getParameter('min'));

        $startDate = $timeSeries->getParameter('start');
        $endDate = $timeSeries->getParameter('end');
        /** @var $startDate Date */
        /** @var $endDate Date */
        $this->assertEquals($today, $startDate->getDate('Y-m-d'));
        $this->assertEquals($today, $endDate->getDate('Y-m-d'));

        $maxDate = $timeSeries->getParameter('maxDate');
        $minDate = $timeSeries->getParameter('minDate');
        /** @var $maxDate Date */
        /** @var $minDate Date */
        $this->assertEquals($today, $maxDate->getDate('Y-m-d'));
        $this->assertEquals($today, $minDate->getDate('Y-m-d'));
    }

    /**
     * @test
     */
    public function Should_Construct_The_Time_Series_Upload_Correctly_Without_Header_And_With_Two_Variables() {
        $this->timeSeriesUploadStdObject->file['tmp_name'] =
            GLOBAL_PATH . '/tests/data/TimeSeriesWithoutHeaderAndWithTwoVariables.csv';
        $timeSeriesUpload = new TimeSeriesUpload($this->timeSeriesUploadStdObject);

        $this->assertEquals('test id', $timeSeriesUpload->getId());

        $this->assertEquals('GMT', $timeSeriesUpload->getParameters()['timezone']);
        $this->assertEquals('description test', $timeSeriesUpload->getParameters()['description']);
        $this->assertEquals('http://test', $timeSeriesUpload->getParameters()['reference_url']);
        $this->assertEquals('0', $timeSeriesUpload->getParameters()['public']);
        $this->assertEquals('admin', $timeSeriesUpload->getParameters()['username']);

        $timeSeriesData = clone($timeSeriesUpload->getTimeSeriesData());

        $this->assertEquals(8, $timeSeriesData->nvalues());
        $this->assertEquals(2, $timeSeriesData->nvars());
        $this->assertEquals(Array (
            0 => 'Value 1',
            1 => 'Value 2'
        ), $timeSeriesData->getColnames());
        $this->assertEquals([26, 35], $timeSeriesData->getMeasures(0));
        $this->assertEquals([12, 325], $timeSeriesData->getMeasures(7));

        $firstDate = $timeSeriesData->getDate(0);
        $this->assertEquals('2014-01-02', $firstDate->getDate('Y-m-d'));

        $lastDate = $timeSeriesData->getDate($timeSeriesData->nvalues() - 1);
        $this->assertEquals('2014-09-01', $lastDate->getDate('Y-m-d'));

        $timeSeries = clone($timeSeriesUpload->getTimeSeries());

        $this->assertEquals($timeSeriesData, $timeSeries->getData());

        $this->assertEquals('test id', $timeSeries->getID());
        $this->assertEquals($timeSeriesData, $timeSeries->getData());
        $this->assertEquals('0', $timeSeries->getParameter('public'));
        $this->assertEquals('admin', $timeSeries->getParameter('username'));
        $this->assertEquals('description test', $timeSeries->getParameter('description'));
        $this->assertEquals('http://test', $timeSeries->getParameter('reference_url'));
        $this->assertEquals('GMT', $timeSeries->getParameter('timezone'));
        $this->assertEquals('1', $timeSeries->getParameter('frequency'));
        $this->assertEquals(8, $timeSeries->getParameter('nvalues'));
        $this->assertEquals(2, $timeSeries->getParameter('nvars'));
        $this->assertEquals(2273.375, $timeSeries->getParameter('mean'));
        $this->assertEquals(6352, $timeSeries->getParameter('max'));
        $this->assertEquals(12, $timeSeries->getParameter('min'));

        $startDate = $timeSeries->getParameter('start');
        $endDate = $timeSeries->getParameter('end');
        /** @var $startDate Date */
        /** @var $endDate Date */
        $this->assertEquals('2014-01-02', $startDate->getDate('Y-m-d'));
        $this->assertEquals('2014-09-01', $endDate->getDate('Y-m-d'));

        $maxDate = $timeSeries->getParameter('maxDate');
        $minDate = $timeSeries->getParameter('minDate');
        /** @var $maxDate Date */
        /** @var $minDate Date */
        $this->assertEquals('2014-02-01', $maxDate->getDate('Y-m-d'));
        $this->assertEquals('2014-08-01', $minDate->getDate('Y-m-d'));
    }

    /**
     * @test
     */
    public function Should_Construct_The_Time_Series_Upload_Correctly_With_Alternative_Dates_Formatted() {
        $this->timeSeriesUploadStdObject->file['tmp_name'] =
            GLOBAL_PATH . '/tests/data/TimeSeriesWithoutHeaderAndWithTwoVariables.csv';
        $this->timeSeriesUploadStdObject->datesFormat = 'Y-d-m';
        $timeSeriesUpload = new TimeSeriesUpload($this->timeSeriesUploadStdObject);

        $this->assertEquals('test id', $timeSeriesUpload->getId());

        $this->assertEquals('GMT', $timeSeriesUpload->getParameters()['timezone']);
        $this->assertEquals('description test', $timeSeriesUpload->getParameters()['description']);
        $this->assertEquals('http://test', $timeSeriesUpload->getParameters()['reference_url']);
        $this->assertEquals('0', $timeSeriesUpload->getParameters()['public']);
        $this->assertEquals('admin', $timeSeriesUpload->getParameters()['username']);

        $timeSeriesData = clone($timeSeriesUpload->getTimeSeriesData());

        $this->assertEquals(8, $timeSeriesData->nvalues());
        $this->assertEquals(2, $timeSeriesData->nvars());
        $this->assertEquals(Array (
            0 => 'Value 1',
            1 => 'Value 2'
        ), $timeSeriesData->getColnames());
        $this->assertEquals([6352, 315], $timeSeriesData->getMeasures(0));
        $this->assertEquals([26, 35], $timeSeriesData->getMeasures(7));

        $firstDate = $timeSeriesData->getDate(0);
        $this->assertEquals('2014-01-02', $firstDate->getDate('Y-m-d'));

        $lastDate = $timeSeriesData->getDate(7);
        $this->assertEquals('2014-02-01', $lastDate->getDate('Y-m-d'));

        $timeSeries = clone($timeSeriesUpload->getTimeSeries());

        $this->assertEquals($timeSeriesData, $timeSeries->getData());

        $this->assertEquals('test id', $timeSeries->getID());
        $this->assertEquals($timeSeriesData, $timeSeries->getData());
        $this->assertEquals('0', $timeSeries->getParameter('public'));
        $this->assertEquals('admin', $timeSeries->getParameter('username'));
        $this->assertEquals('description test', $timeSeries->getParameter('description'));
        $this->assertEquals('http://test', $timeSeries->getParameter('reference_url'));
        $this->assertEquals('GMT', $timeSeries->getParameter('timezone'));
        $this->assertEquals('1', $timeSeries->getParameter('frequency'));
        $this->assertEquals(8, $timeSeries->getParameter('nvalues'));
        $this->assertEquals(2, $timeSeries->getParameter('nvars'));
        $this->assertEquals(2273.375, $timeSeries->getParameter('mean'));
        $this->assertEquals(6352, $timeSeries->getParameter('max'));
        $this->assertEquals(12, $timeSeries->getParameter('min'));

        $startDate = $timeSeries->getParameter('start');
        $endDate = $timeSeries->getParameter('end');
        /** @var $startDate Date */
        /** @var $endDate Date */
        $this->assertEquals('2014-01-02', $startDate->getDate('Y-m-d'));
        $this->assertEquals('2014-02-01', $endDate->getDate('Y-m-d'));

        $maxDate = $timeSeries->getParameter('maxDate');
        $minDate = $timeSeries->getParameter('minDate');
        /** @var $maxDate Date */
        /** @var $minDate Date */
        $this->assertEquals('2014-01-02', $maxDate->getDate('Y-m-d'));
        $this->assertEquals('2014-01-08', $minDate->getDate('Y-m-d'));
    }
}