<?php
namespace TimeSeriesAnalysisWebApi\libs\database;

interface IDatabase {
    public function get();
    public function insert();
    public function update();
    public function delete();
}