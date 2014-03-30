package RentalUnits::DB::Application;

use strict;
use warnings;

use RentalUnits::DB;
use Rose::DB::Object::Manager;
use parent 'RentalUnits::DB::Object';

__PACKAGE__->meta()->setup(
  schema  => 'rnt_tst',
  table   => 'application',
  auto    => 1,
);

# generate RentalUnits::DB::Application::Manager object
__PACKAGE__->meta()->make_manager_class('application');

1;
