package RentalUnits::App::User;

use Mojo::Base 'Mojolicious::Controller';

use RentalUnits::DB::UserBasics;

sub get_all_users {
  my $self = shift;

  my $iterator = RentalUnits::DB::UserBasics::Manager->get_user_basics_iterator();
  
  my $users_ref; # arrayref
  my $user_ref; # hashref
  while ( my $user = $iterator->next() ) {
    $user_ref->{username} = $user->username();
    $user_ref->{pwd} = $user->{pwd};
    $user_ref->{last_name} = $user->{last_name};
    $user_ref->{first_name} = $user->{first_name};
    $user_ref->{middle_name} = $user->{middle_name};
    $user_ref->{email} = $user->{email};
    push @{$users_ref}, $user_ref;
  }

  $self->render( json => { users => $users_ref, } );

  return;
}

1;
