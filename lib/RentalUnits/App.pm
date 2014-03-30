package RentalUnits::App;

use Mojo::Base 'Mojolicious';

#use RentalUnits::DB;

sub startup {
  my $self = shift;  

  $self->routes()->get('/all_users')->to(   
    controller => 'User',
    action     => 'get_all_users',
  );

  return;
}	

1;
