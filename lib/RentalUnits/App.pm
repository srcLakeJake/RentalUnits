package RentalUnits::App;

use Mojo::Base 'Mojolicious';

# use Mojolicious::Plugin::Authentication;

sub startup {
  my $self = shift;  

  $self->secret('My_h0v3rCr@fT_1$_Fuil_oF_e3l$#');
  
  push @{ $self->plugins()->namespaces() }, 'RentalUnits::Plugin';  
  $self->plugin( 'StdApp', {} );  

  $self->routes()->get('/all_users')->to(   
    controller => 'User',
    action     => 'get_all_users',
  );

  # $self->routes()->get('/application/:app_id')->to(
    # controller => 'Application',
    # action     => 'get_application',
    # validation_class => 'RentalUnits::Validation::Application',
  # );

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
  
  my $auth2 = $self->routes()->bridge('/auth2')->to(cb => sub {
      my $self = shift;
	  
	  if ( ! $self->is_user_authenticated() ) {
	      $self->render( json => { message => 'You\'d better log in if you want to view this page' } );
		  return;
	  }
	  
	  return 1;
  });
  
  $auth2->route('/secured_stuff')->to(
      controller => 'Stuff',
	  action      => 'show_stuff',
  ); 
  
  $auth2->get('/application/:app_id')->to(
    controller => 'Application',
    action     => 'get_application',
    validation_class => 'RentalUnits::Validation::Application',
  );

  return;
}

1;
