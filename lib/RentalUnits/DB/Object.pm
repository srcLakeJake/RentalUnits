package RentalUnits::DB::Object;

use RentalUnits::DB;

use parent 'Rose::DB::Object';

sub init_db { RentalUnits::DB->new(); }

1;
