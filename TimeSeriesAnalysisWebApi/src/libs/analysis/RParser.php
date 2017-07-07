<?php
namespace TimeSeriesAnalysisWebApi\libs\analysis;

class RParser {
	
    public static function parserJson($json, $outputIndex) {
        $json = $json[$outputIndex][1];
        $parsed_json = json_decode(str_replace("[1] ", "", $json));
        $parsed_json = json_decode(json_encode($parsed_json), true);

        return $parsed_json;
    }
}
