package RentalUnits::App::Application;

use Mojo::Base 'Mojolicious::Controller';

# use Mojolicious::Validator;
# use Mojolicious::Validator::Validation;
# use Mojolicious::Plugin::FormValidator; # DFV based plugin

use RentalUnits::DB::Application;

sub get_application {
  my $self = shift;

  if ( ! $self->is_user_authenticated() ) {            
      $self->render( json => { message => 'You must log in to view this page.', } );
	  return;
  }

  my $validation = $self->validation();
  $validation->input({ app_id => $self->param('app_id') });
  $validation->required('app_id')->in('1');
  
  # Execute branch only if validation succeeded. $validation->param('app_id') 
  # will be empty if validation failed
  if ( $validation->param('app_id') ) {
      
	  my $appl_obj = RentalUnits::DB::Application->new( app_id => $validation->param('app_id') );
      $appl_obj->load();
  
      my $application_ref;
      for my $column ( $appl_obj->meta()->columns() ) {
        $application_ref->{$column} = $appl_obj->$column();
      }
	  
	  $self->render( json => { application => $application_ref, } );
	  return;
  }
  
  # Validation failed
  $self->render( json => { message => 'Piss off!', } );
  return;
}

# POST parameters accessed through $self->param
# stack contains the hash elements passed to the route in App.pm
sub post_application {
  my $self = shift;  
  
  my @params = $self->param();
  my @stack = @{ $self->match()->stack() };

  $self->render( json => { 
      foo => $self->param('foo'),
	  bar => $self->param('bar'),
	  xyz => $self->param('xyz'),	  
	  stack => @stack,
  } );

  return;
}

1;
