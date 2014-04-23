package RentalUnits::App::Stuff;

use Mojo::Base 'Mojolicious::Controller';

sub show_stuff {
    my $self = shift;
	
	$self->render( json => {  stuff => 'Top secret!' } );
	
	return;
}

1;