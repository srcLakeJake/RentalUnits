package RentalUnits::DB;

use Rose::DB;
our @ISA = qw{Rose::DB};

__PACKAGE__->use_private_registry();

__PACKAGE__->register_db(
  driver   => 'mysql',
  database => 'rnt_tst',
  host     => 'localhost',
  username => 'root',
  password => 'tortoise05',
);

1;
