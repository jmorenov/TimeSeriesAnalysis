<?php
function responseJSON(\Slim\Http\Response $response, $data) {
    $response = $response->withHeader('Content-type', 'application/json');
    $data = json_encode($data, JSON_PRETTY_PRINT);

    return $response->write($data);
}