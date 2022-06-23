<?php
error_reporting(E_ALL);
const DB_HOST = 'localhost';
const DB_USER = 'root';
const DB_PASSWORD = 'root';
const DB_NAME = 'testexpress';

$connection = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
if ($connection->connect_error) {
    die('Connection failed: ' . $connection->connect_error);
}
