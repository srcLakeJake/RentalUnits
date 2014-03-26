package RentalUnits::DB::UserBasics;

use strict;
use warnings;

use parent 'Rose::DB::Object';

__PACKAGE__->meta()->setup(
  schema => 'rnt_tst',
  table  => 'user_basics',
  auto   => 1,
);

1;
