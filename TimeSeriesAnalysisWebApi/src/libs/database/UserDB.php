<?php
namespace TimeSeriesAnalysisWebApi\libs\database;

use Exception;
use TimeSeriesAnalysisWebApi\models\User;
use TimeSeriesAnalysisWebApi\libs\utils\Config;
use TimeSeriesAnalysisWebApi\libs\utils\Random;

class UserDB extends Database {
    private static $instance;

    private function encryptPassword($password) {
        return hash('sha512', $password);
    }

    protected function __construct() {
        parent::__construct();

        $this->dbname = Config::getInstance()->get("database", "name");
    }

    public function insert(User $user = null, $password = null) {
        if($user == null || $password == null) {
            throw new Exception('User creation: Missing fields');
        }

        if($this->get($user->getUsername(), $user->getEmail())) {
            throw new Exception('User creation: This user already exists');
        }

        $password = $this->encryptPassword($password);
        $username = $user->getUsername();
        $email = $user->getEmail();
        $name = $user->getName();
        $this->query = "INSERT INTO users (username, password, email, full_name) "
            . "VALUES('$username', '$password', '$email', '$name')";
        $error = $this->execute_single_query();

        if(is_string($error) && $error != '') {
            throw new Exception('User creation: ' . $error);
        }

        $user = $this->get($user->getUsername(), $user->getEmail());

        if(!$user) {
            throw new Exception('User creation: Error creating user');
        }

        try {
            TimeSeriesDB::getInstance()->createTimeSeriesDataDatabaseForUser($user->getUsername());
        } catch (Exception $ex) {
            $this->delete($user->getUsername());

            throw new Exception('User creation: Error creating timeseries database for user');
        }

        return $user;
    }

    public function get($username = null, $email = null, $withAuthToken = false) {
        $this->query = "SELECT username, email, full_name, auth_token FROM users";
        if($username != null) {
            $this->query .= " WHERE username='$username'";
            if($email != null) {
                $this->query .= " OR email='$email'";
            }
        } else if ($email != null) {
            $this->query .= " WHERE email='$email'";
        }

        $error = $this->get_results_from_query();

        if(is_string($error) && $error != '') {
            throw new Exception('User get: ' . $error);
        }

        $result = [];
        if(count($this->rows) >= 1) {
            foreach ($this->rows as $row) {
                if (!$withAuthToken) {
                    $row['auth_token'] = '';
                    $row['authToken'] = '';
                }

                $result[] = new User($row);
            }
            return count($result) > 1 ? $result : $result[0];
        }
        return false;
    }

    public function update(User $user = null, $password = null) {
        if($user == null) {
            throw new Exception('User updating: Error missing data');
        }

        $username = $user->getUsername();
        $email = $user->getEmail();
        $name = $user->getName();
        $authToken = $user->getAuthToken();
        $this->query = "UPDATE users SET email='$email', full_name='$name', auth_token='$authToken'";

        if($password != null) {
            $password = $this->encryptPassword($password);
            $this->query .= ", password='$password'";
        }

        $this->query .= "WHERE username='$username'";
        $error = $this->execute_single_query();

        if(is_string($error) && $error != '') {
            throw new Exception('User updating: ' . $error);
        }

        if(!$this->get($user->getUsername(), $user->getEmail())) {
            throw new Exception('User updating: Error updating user');
        }

        return $user;
    }

    public function delete($username = null) {
        if($username == null) {
            throw new Exception('User delete: Error missing data');
        }

        if($this->get($username)) {
            $this->query = "DELETE FROM users WHERE username=" . $username;
            $error = $this->execute_single_query();

            if(is_string($error) && $error != '') {
                throw new Exception('User delete: ' . $error);
            }

            return true;
        } else {
            throw new Exception('User delete: user not found');
        }
    }

    public static function getInstance() {
        if (!self::$instance instanceof self) {
            self::$instance = new self;
        }
        return self::$instance;
    }

    public function generateAuthToken(User $user) {
        $authToken = hash('sha512', Random::generateRandomString() . $user->getUsername() . Random::generateRandomString());
        $user->setAuthToken($authToken);
        $this->update($user);

        return $user;
    }

    public function authUser($username, $authToken) {
        $user = $this->get($username, '', true);

        if ($user) {
            if($user->getAuthToken() == $authToken) {
                return true;
            }
        }

        return false;
    }

    public function login($username, $password) {
        if($username == null || $password == null) {
            throw new Exception('Error user login: missing fields');
        }

        $encryptPassword = $this->encryptPassword($password);
        $this->query = "SELECT username, email, full_name FROM users WHERE username='$username' AND password='$encryptPassword'";
        $error = $this->get_results_from_query();

        if(is_string($error) && $error != '') {
            throw new Exception('Error user login: ' . $error);
        }

        if(count($this->rows) >= 1) {
            $user = new User($this->rows[0]);
            $user = $this->generateAuthToken($user);
            return $user;
        } else {
            throw new Exception('Error user login: user not found');
        }
    }

    public function validateUsername($username) {
        if ($this->get($username)) {
            return false;
        }

        return true;
    }

    public function validateEmail($email) {
        if ($this->get('', $email)) {
            return false;
        }

        return true;
    }
}