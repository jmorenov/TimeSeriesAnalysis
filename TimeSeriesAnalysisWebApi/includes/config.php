<?php
$config = TimeSeriesAnalysisWebApi\libs\utils\Config::getInstance();

/**
 * Main Configuration
 */
$config->set("main", "site_path", GLOBAL_PATH);
$config->set("main", "default_timezone", "UTC");

/**
 * Error Configuration
 */
$config->set("error", "ERROR", "Error sin definir");

/**
 * Time series Configuration
 */
$config->set("timeseries", "test", "test");

/**
 * Database Configuration
 */
$config->set("database", "host", "host.com");
$config->set("database", "user", "root");
$config->set("database", "pass", "root");
$config->set("database", "name", "database_name");
$config->set("database", "port", 3307);
$config->set("timeseriesdatabase", "host", "host.com");
$config->set("timeseriesdatabase", "port", 20402);
$config->set("timeseriesdatabase", "user", "admin");
$config->set("timeseriesdatabase", "pass", "admin");
$config->set("timeseriesdatabase", "name", "database_name");

/**
 * Rscript Configuration
 */
$config->set("rscript", "r_path", "/usr/bin/R");
$config->set("rscript", "r_script_path", GLOBAL_PATH . "/src/RScripts/");
$config->set("rscript", "r_lib", "/opt/Rlib");