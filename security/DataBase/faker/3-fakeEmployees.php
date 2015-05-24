<?php
include_once(dirname(dirname(dirname(__DIR__))) . DIRECTORY_SEPARATOR . 'vendor/autoload.php');

use \security\Models\Generator\RandomGenerator;
use \security\Models\MySQLISingleton;

$rand = new RandomGenerator();

$mysqli = new MySQLISingleton();

$faker = Faker\Factory::create();

// percent chance a user will be an admin
$chance = 10;

$fakeUsers = 150;

$mysqlValues = $sqliteValues = [];

/**
 * Note:  addslashes is a bad idea because it only adds slashes as an escape sequence.  
 * Depending upon the database, most notably SQLite, it follows the SQL standard of a 
 * backslash followed by a single quote as the proper escape sequence, 
 * while MySQL just uses the backslash as an escape sequence.  Prepared statements are better than 
 * relying upon these sorts of escape quote functions.
 * 
 * Even within escaped characters recognized by addslashes, it does not recognize the correct encoding.  
 * There are a certain class of injection attacks that take advantage of this to insert malicious data.
 */

// Create a default set of admin users so that each company will have at least one admin.

for ($i = 1; $i <= $fakeUsers; $i++) {
    $username = $faker->userName;
    $mysqlUsername = $mysqli->real_escape_string($username);
    $sqliteUsername = SQLite3::escapeString($username);

    $email = $faker->safeEmail;
    $mysqlEmail = $mysqli->real_escape_string($email);
    $sqliteEmail = SQLite3::escapeString($email);
    
    $phone = str_shuffle($faker->numerify('##########'));
    $is_admin = 0;
    if ($rand->returnRandomNumber(0, 100) <= $chance) {
        $is_admin = 1; 
    }
    $is_locked = 0;
    $attempts = 0;
    $group_id = $faker->numberBetween(1, 40);
    
    $plainpassword = $faker->password;
    $mysqlPlainpassword = $mysqli->real_escape_string($plainpassword);
    $sqlitePlainpassword = SQLite3::escapeString($plainpassword);
    
    $mysqlPassword = password_hash($mysqlPlainpassword, PASSWORD_DEFAULT);
    $sqlitePassword = password_hash($sqlitePlainpassword, PASSWORD_DEFAULT);
    
    $company_id = mt_rand(1, 10); 
    
    if ($i < 10) {
        $mysqlUsername = $sqliteUsername = "mike{$i}";  
        
        $email = $faker->safeEmail;
        $mysqlEmail = $mysqli->real_escape_string($email);
        $sqliteEmail = SQLite3::escapeString($email);
        
        $phone = $faker->unique()->numerify('##########');
        $is_admin = 1;
        $is_locked = 0;
        $attempts = 0;
        
        $plainpassword = $mysqlPlainpassword = $sqlitePlainpassword = 'password1234';
        $mysqlPassword = $sqlitePassword = password_hash($plainpassword, PASSWORD_DEFAULT);
        $company_id = $i; 
    }
    $mysqlQuery = "INSERT INTO users (`username`,`email`,`phone`,`company_id`,`is_admin`,`is_locked`,
             `attempts`,`password`, `plainpassword`, `group_id`) VALUES 
              ('$mysqlUsername', '$mysqlEmail', '$phone', $company_id, $is_admin, 
              $is_locked, $attempts, '$mysqlPassword', '$mysqlPlainpassword', '$group_id')";    

    $sqliteQuery = "INSERT INTO users (`username`,`email`,`phone`,`company_id`,`is_admin`,`is_locked`,
             `attempts`,`password`, `plainpassword`, `group_id`) VALUES 
              ('$sqliteUsername', '$sqliteEmail', '$phone', $company_id, $is_admin, 
              $is_locked, $attempts, '$sqlitePassword', '$sqlitePlainpassword', '$group_id')";    
    
    $mysqlValues[] = $mysqlQuery;
    $sqliteValues[] = $sqliteQuery;
}

// Begin MySQL SQL statements.

$valueString = implode(";".PHP_EOL,$mysqlValues);
$valueString .= ";";
$valueString .= PHP_EOL . "--//@UNDO" . PHP_EOL . "SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE users; 
SET FOREIGN_KEY_CHECKS = 1;" . PHP_EOL . "--//";
$seedsFile = dirname(__DIR__) . "/deltas/seeds/mysql/12-companyUserSeeds.sql";
if (!file_exists($seedsFile)) {
    touch($seedsFile);
}
file_put_contents($seedsFile, $valueString);

/**
 * Begin SQLite Preparations
 */

$valueString = implode(";".PHP_EOL,$sqliteValues);
$valueString .= ";";
$valueString .= PHP_EOL . "--//@UNDO" . PHP_EOL . "PRAGMA foreign_keys=OFF;
delete from users;
PRAGMA foreign_keys=ON; 
" . PHP_EOL . "--//";
$seedsFile = dirname(__DIR__) . "/deltas/seeds/sqlite/12-companyUserSeeds.sql";
if (!file_exists($seedsFile)) {
    touch($seedsFile);
}
file_put_contents($seedsFile, $valueString);