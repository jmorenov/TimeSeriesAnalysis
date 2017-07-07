<?php
namespace TimeSeriesAnalysisWebApi\models;

use JsonSerializable;
use Exception;

class User implements JsonSerializable {
    private $username;
    private $email;
    private $name;
    private $authToken;

    public function __construct(array $userArray) {
        if (!isset($userArray['username'])) {
            throw new Exception('Error in user: Missing username');
        }

        if (!isset($userArray['email'])) {
            throw new Exception('Error in user: Missing email');
        }

        if (!isset($userArray['full_name'])) {
            if (isset($userArray['name'])) {
                $userArray['full_name'] =  $userArray['name'];
            } else if (isset($userArray['fullName'])) {
                $userArray['full_name'] =  $userArray['fullName'];
            } else {
                $userArray['full_name'] =  '';
            }
        }

        if (!isset($userArray['auth_token'])) {
            if (isset($userArray['authToken'])) {
                $userArray['auth_token'] =  $userArray['authToken'];
            } else if (isset($userArray['token'])) {
                $userArray['auth_token'] =  $userArray['token'];
            } else {
                $userArray['auth_token'] =  '';
            }
        }

        $this->create($userArray['username'], $userArray['email'], $userArray['full_name'], $userArray['auth_token']);
    }

    private function create($username, $email, $name = '', $authToken = '') {
        $this->username = $username;
        $this->email = $email;
        $this->setName($name);
        $this->authToken = $authToken;
    }

    public function setName($name) {
        $this->name = $name;
    }

    public function setAuthToken($authToken) {
        $this->authToken = $authToken;
    }
    
    public function getUsername() {
        return $this->username;
    }
    
    public function getEmail() {
        return $this->email;
    }
    
    public function getName() {
        return $this->name;
    }

    public function getAuthToken() {
        return $this->authToken;
    }

    public function jsonSerialize() {
        return [
            'username' => $this->getUsername(),
            'email' => $this->getEmail(),
            'name' => $this->getName(),
            'authToken' => $this->getAuthToken()
        ];
    }
}
