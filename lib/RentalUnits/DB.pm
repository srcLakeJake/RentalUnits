package RentalUnits::DB;

use parent 'Rose::DB';

__PACKAGE__->use_private_registry();

__PACKAGE__->register_db(
  driver   => 'mysql',
  database => 'rnt_tst',
  host     => 'localhost',
  username => 'root',
  password => 'tortoise05',
);

1;
