<?php
namespace TimeSeriesAnalysisWebApi\libs\utils;

class Config {
    private static $instance;
    private $configurations;

    private function __construct() {
        $this->configurations = [];
    }

    public static function getInstance() {
        if (!self::$instance instanceof self) {
            self::$instance = new self;
        }
        return self::$instance;
    }
    
    public function get($group, $name) {
        // Exception!!!
        return $this->configurations[$group][$name];
    }
    
    public function set($group, $name, $value) {
        $this->configurations[$group][$name] = $value;
    }
}
