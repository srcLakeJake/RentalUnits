package RentalUnits::App::Application;

use Mojo::Base 'Mojolicious::Controller';

use RentalUnits::DB::Application;

sub get_application {
  my $self = shift;

  my $id = $self->param('id');

  my $appl_obj = RentalUnits::DB::Application->new( app_id => $id );
  $appl_obj->load();
  
  my $application_ref;
  $application_ref->{app_id} = $appl_obj->app_id();
  $application_ref->{person_id} = $appl_obj->person_id();
  $application_ref->{submit_date} = $appl_obj->submit_date();
  $application_ref->{is_smoker} = $appl_obj->is_smoker();
  $application_ref->{has_broken_lease} = $appl_obj->has_broken_lease();
  $application_ref->{has_refused_rent} = $appl_obj->has_refused_rent();
  $application_ref->{been_evicted} = $appl_obj->been_evicted();
  $application_ref->{filed_bankruptcy} = $appl_obj->filed_bankruptcy();
  $application_ref->{been_convicted} = $appl_obj->been_convicted();
  $application_ref->{criminal_check_auth} = $appl_obj->criminal_check_auth();
  $application_ref->{credit_check_auth} = $appl_obj->credit_check_auth();
  $application_ref->{reason_no_utils} = $appl_obj->reason_no_utils();
  $application_ref->{reason_no_rent} = $appl_obj->reason_no_rent();

  $self->render( json => { application => $application_ref, } );

  return;
}

1;
