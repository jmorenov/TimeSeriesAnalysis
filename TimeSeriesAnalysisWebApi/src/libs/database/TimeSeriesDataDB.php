<?php
namespace TimeSeriesAnalysisWebApi\libs\database;

use TimeSeriesAnalysisWebApi\libs\utils\Config;

abstract class TimeSeriesDataDB implements IDatabase {
    protected static $host;
    protected static $user;
    protected static $pass;
    protected static $port;
    protected static $dbname;

    public function __construct() {
        self::$host = Config::getInstance()->get("timeseriesdatabase", "host");
        self::$port = Config::getInstance()->get("timeseriesdatabase", "port");
        self::$user = Config::getInstance()->get("timeseriesdatabase", "user");
        self::$pass = Config::getInstance()->get("timeseriesdatabase", "pass");
        self::$dbname = Config::getInstance()->get("timeseriesdatabase", "name");
    }
}