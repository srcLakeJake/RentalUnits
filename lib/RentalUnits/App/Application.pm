package RentalUnits::App::Application;

use Mojo::Base 'Mojolicious::Controller';

use RentalUnits::DB::Application;

sub get_application {
  my $self = shift;

  my $id = $self->param('id');

  my $appl_obj = RentalUnits::DB::Application->new( app_id => $id );
  $appl_obj->load();
  
  my $application_ref;
  for my $column ( $appl_obj->meta()->columns() ) {
    $application_ref->{$column} = $appl_obj->$column();
  }

  $self->render( json => { application => $application_ref, } );

  return;
}

1;
