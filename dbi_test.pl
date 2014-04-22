#! /usr/bin/perl

use strict;
use warnings;

use DBI;

my $dbh = DBI->connect(
  'dbi:mysql:rnt_tst',
  'root',
  'tortoise05'
) or die "Connection error: $DBI::errstr\n";

my $sql = 'select * from user_basics';
my $sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";

while ( my @row = $sth->fetchrow_array() ) {
  print "@row\n";
}
