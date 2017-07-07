<?php
namespace TimeSeriesAnalysisWebApi\libs\analysis;

use \Kachkaev\PHPR\RCore;
use \Kachkaev\PHPR\Engine\CommandLineREngine;
use TimeSeriesAnalysisWebApi\libs\utils\Config;

class RScript {
    private $rcore;
    private $script;
    private $rlib;
    private $rScriptPath;
    private $config;

    public function __construct($script) {
        $this->config = Config::getInstance();
        $this->rlib = $this->config->get("rscript", "r_lib");
        $this->rScriptPath = $this->config->get("rscript", "r_script_path");
        $this->rcore = new RCore(new CommandLineREngine($this->config->get("rscript", "r_path")));
        $this->script = $script;
    }
    
    public function run($outputIndex, array $parameters = null) {
        $file_string = file_get_contents($this->script);

        if($parameters != null) {
            foreach($parameters as $key=>$value) {
                $file_string = $key . "<-" . $value . "\n" . $file_string;
            }
        }

        $file_string = "r_lib" . "<-'" . $this->rlib . "'\n" . $file_string;
        $file_string = "r_script_path" . "<-'" . $this->rScriptPath . "'\n" . $file_string;

        $result = $this->rcore->run($file_string, true);

        $parsedResult = RParser::parserJson($result, $outputIndex + 2);

        if ($parsedResult == null) {
            $result = $this->rcore->run($file_string, true);

            $parsedResult = RParser::parserJson($result, $outputIndex + 2);
        }

        return $parsedResult;
    }
}