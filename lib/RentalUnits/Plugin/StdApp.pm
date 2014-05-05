package RentalUnits::Plugin::StdApp;

use Mojo::Base 'Mojolicious::Plugin';
use Mojolicious::Plugin::Authentication;

sub register {
    my ( $self, $app, $conf ) = @_;
	
	$app->plugin( 'authentication' => {
      #'autoload_user' => 1,
	  'session_key' => 'turds',
	  'load_user' => $self->authorize_user(),
	  'validate_user' => $self->authenticate_user(),	  
	  #'current_user_fn' => 'user',
  });
  
  # set default session expiration to 10 seconds (for testing)
  $app->sessions->default_expiration(10);
  
}

sub authenticate_user {
    return sub {
          my ( $app, $username, $pwd, $extradata ) = @_;		
	      my %creds = (
	          jake => 'abc123',
		      maki => 'xyz789',
	      );	
	      if ( exists $creds{$username} ) {
	          if ( $creds{$username} eq $pwd ) {
		          return $username;
		  }
		  else {
		      return undef;
		  }
	  }
	  else {
	      return undef;
	  }	
	  return undef;
    };
}

sub authorize_user {
    return sub {
	    my ( $app, $uid ) = @_;	
	      my %users = (
	          jake => {
		          group => 'admins',
			      name  => 'Jake Gittes',
		      },
		      maki => {
		          group => 'basic',
			      name  => 'Maki T',
		      },
	      );
		  my $user;
	      if ( exists $users{$uid} ) {
	          $user = \$users{$uid};
	      }	
	      return $user;
	};
}

1;