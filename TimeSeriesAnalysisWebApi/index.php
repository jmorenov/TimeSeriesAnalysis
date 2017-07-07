<?php
define('GLOBAL_PATH', __DIR__);

require_once 'includes/bootstrap.php';

\TimeSeriesAnalysisWebApi\libs\application\Application::getInstance()->run();