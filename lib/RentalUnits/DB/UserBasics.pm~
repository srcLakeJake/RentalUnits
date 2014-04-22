package RentalUnits::DB::UserBasics;

use strict;
use warnings;

use RentalUnits::DB;
use Rose::DB::Object::Manager;
use parent 'RentalUnits::DB::Object';

__PACKAGE__->meta()->setup(
  schema  => 'rnt_tst',
  table   => 'user_basics',
  columns => [ 
    qw(
      username
      pwd
      last_name
      first_name
      middle_name
      email
    ) 
  ],
  pk_columns => 'username',
  unique_key => 'email',
  #auto   => 1,
);

__PACKAGE__->meta()->make_manager_class('user_basics');

1;
