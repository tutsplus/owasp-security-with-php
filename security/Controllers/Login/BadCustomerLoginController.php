<?php

namespace security\Controllers\Login;

require_once(dirname(dirname(dirname(__DIR__))). DIRECTORY_SEPARATOR . 'public/init.php');

use \security\Models\Authenticator\Authenticate;
use \security\Models\ErrorRunner;
use \security\Models\PDOSingleton;
use \security\Models\Login\CustomerLogin;
use \security\Models\RedisSingleton;
use \security\Models\Authenticator\BlackLister;
use \PDO;
use \JsonSerializable;
use \Redis;
use \SplObjectStorage;
use \StdClass;
use \security\Controllers\Login\BaseLogin;

class CustomerLoginController extends BaseLoginController
{
    private $errors = [];
    private $userName;
    private $password;
    private $jsonObject = [];

    public function __construct(stdClass $models, stdClass $customerLoginData)
    {
        parent::__construct($models);
        $this->customerLoginData = $customerLoginData;
        $this->setObjects();
        $this->customerLoginModel = new CustomerLogin($models);
    }
    protected function setObjects()
    {
        parent::setObjects();
        $this->setUserName($this->customerLoginData->userName);
        $this->setPassword($this->customerLoginData->password);
        $this->setAction($this->customerLoginData->action);
    }
    public function setUserName($userName)
    {
        $this->userName = $userName;
    }
    public function setAction($action)
    {
        $this->action = $action;
    }
    public function setPassword($password)
    {
        $this->password = $password;
    }
    public function executeAction()
    {
        $action = $this->action;
        switch($action) {
            case 'verifyLogin':
                $return = $customerLogin->checkUser(
                    $this->userName,
                    $this->password
                );
                if (isset($return['errors']) && !empty($return['errors'])) {
                    $this->errors[] = $return['errors'];
                    $this->errorRunner->runErrors($this->errors);
                }
                $this->jsonObject = $return;
                break;
            default:
                $this->errors[] = "No such action exists.";
                $this->errorRunner->runErrors($this->errors);
                break;
        }
    }
    public function jsonSerialize()
    {
        return $this->jsonObject;
    }
}

$errors = [];

$auth = new Authenticate();
$errorRunner = new ErrorRunner();
$redis = new RedisSingleton();
$blackList = new BlackLister($redis);
$isAjax = (isset($_POST['isAjax']) && $auth->isAjax()) ? true : false;
$pdo = new PDOSingleton();

$userName = !empty($_POST['userName']) ? $_POST['userName'] : null;
$password = !empty($_POST['password']) ? $_POST['password'] : null;
$action = !empty($_POST['action']) ? $_POST['action'] : null;

$userName || $errors[] = "No email was sent over.";
$password || $errors[] = "No password was sent over.";
$action = $action || $errors[] = "No action to perform was sent over.";
$errors[] = "A required field was missing.";

if (empty($errors)) {
    $modelObjects = new StdClass();
    $modelObjects->pdo = $pdo;
    $modelObjects->redis = $redis;
    $modelObjects->errorRunner = $errorRunner;
    $modelObjects->blackList = $blackList;

    $customerLoginData = new StdClass();
    $customerLoginData->userName = $userName;
    $customerLoginData->password = $password;
    $customerLoginData->action = $action;

    $controller = new CustomerLoginController($models, $customerLoginData);
    $controller->executeAction();
    if ($isAjax) {
        echo json_encode($controller);
    }
}

if (!empty($errors)) {
    $errorRunner->runErrors($errors);
}
