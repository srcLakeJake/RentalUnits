#! /user/bin/perl

use strict;
use warnings;

use Rose::DB;

register_db(
  type     => 'main',
  driver   => 'mysql',
  database => 'rnt_tst',
  host     => 'localhost',
  username => 'root',
  password => 'tortoise05',
);
