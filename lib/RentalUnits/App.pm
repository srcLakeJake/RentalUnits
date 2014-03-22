package RentalUnits::App;

use Mojo::Base 'Mojolicious';

sub startup {
  my $self = shift;

  # Plugins

  $self->routes()->get('/user')->to(
    controller => 'RentalUnits::App::User',
    action     => 'get_user',
  );

  return;
}

1;