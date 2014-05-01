package RentalUnits::App::Login;

use Mojo::Base 'Mojolicious::Controller';

sub log_in {
  my $self = shift;
	
  my $username = $self->param('username');
  my $password = $self->param('password');	
  
  my $auth_msg;
  if ( $self->authenticate( $username, $password, ) ) {
      $auth_msg = "Login succeeded!\n";
  }
  else {
      $auth_msg = "Login failed.\n";
  }

  $self->render( json => { 
      auth_message => $auth_msg,
  } );
  
  return;
}

1;