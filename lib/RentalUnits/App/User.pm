package RentalUnits::App::User;

use Mojo::Base 'Mojolicious::Controller';

sub get_user {
  my $self = shift;

  my $test = 'srcLakeJake';

  $self->render( json => { user => $test, } );

  return;
}

1;
