package RentalUnits::App;

use Mojo::Base 'Mojolicious';

#use RentalUnits::DB;

sub startup {
  my $self = shift;  

  $self->secret('My_h0v3rCr@fT_1$_Fuil_oF_e3l$#');

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

1;
