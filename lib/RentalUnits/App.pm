package RentalUnits::App;

use Mojo::Base 'Mojolicious';

use Mojolicious::Plugin::Authentication;
#use RentalUnits::DB;

sub startup {
  my $self = shift;  

  $self->secret('My_h0v3rCr@fT_1$_Fuil_oF_e3l$#');
  
  $self->plugin( 'authentication' => {
      #'autoload_user' => 1,
	  'session_key' => 'turds',
	  'load_user' => sub {
          my ( $app, $uid ) = @_;	
	      my %users = (
	          jake => {
		          group => 'admins',
			      name  => 'Jake Mabee',
		      },
		      maki => {
		          group => 'basic',
			      name  => 'Maki Tanigaki',
		      },
	      );
		  my $user;
	      if ( exists $users{$uid} ) {
	          $user = \$users{$uid};
	      }	
	      return $user;
      },
	  'validate_user' => sub {
          my ( $app, $username, $pwd, $extradata ) = @_;		
	      my %creds = (
	          jake => 'canoes05',
		      maki => 'minipanda',
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
    },
	#'current_user_fn' => 'user',
  });

  $self->routes()->get('/all_users')->to(   
    controller => 'User',
    action     => 'get_all_users',
  );

  $self->routes()->get('/application/:id')->to(
    controller => 'Application',
    action     => 'get_application',
    validation_class => 'RentalUnits::Validation::Application',
  );

  $self->routes()->post('/application')->to(
    controller => 'Application',
    action     => 'post_application',
    validation_class => 'RentalUnits::Validation::Application',
  );
  
  $self->routes()->post('/login/:username/:password')->to(
    controller => 'Login',
    action     => 'log_in',    
  );
  
  my $auth = $self->routes()->bridge('/auth')->to(cb => sub {
      my $self = shift;
	  
	  print "Got here";
	  
	  #Failed authentication
	  $self->render( json => {auth => 'failed. name not provided' } );
	  return if not $self->param('name');
	  
	  # Successful authentication
	  return 1 if $self->param('name') eq 'Jake';
	  
	  # Failed authentication
	  $self->render( json => {auth => 'failed. name not Jake' } );
	  return undef;
  });
  $auth->route('/secured_stuff')->to(
      controller => 'Stuff',
	  action      => 'show_stuff',
  );  

  return;
}	

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

sub load_user {
    my ( $app, $uid ) = @_;
	
	my %users = (
	    jake => {
		    group => 'admins',
			name  => 'Jake Mabee',
		},
		maki => {
		    group => 'basic',
			name  => 'Maki Tanigaki',
		},
	);
	
	my $user;
	if ( exists $users{$uid} ) {
	    $user = \$users{$uid};
	}
	
	return $user;
}

sub validate_user {
    my ( $app, $username, $pwd, $extradata ) = @_;	
	
	my %creds = (
	    jake => 'canoes05',
		maki => 'minipanda',
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
}	

1;
