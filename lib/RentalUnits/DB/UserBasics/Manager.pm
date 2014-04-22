package RentalUnits::DB::UserBasics::Manager;

use parent 'Rose::DB::Object::Manager';

sub object_class { 'RentalUnits::DB::UserBasics' }

__PACKAGE__->make_manager_methods('user_basics');

1;
