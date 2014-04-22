package RentalUnits::Plugin::Utils;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app, $conf ) = @_;
	
	$app->helper(
	    full_stack_params => sub {
		    my $self = shift;
			
			return $self->stash('full_stack_params')
			    if $self->stash('full_stack_params');
				
		    my %p;
			for my $stack_item_ref ( @{ $self->match()->stack() } ) {
			    for my $param_name ( keys %{$stack_item_ref} ) {
				    $p{$param_name} = $stack_item_ref->{$param_name}
					    if not $self->is_reserved_stash_keyword( $param_name );
				}
			}
			
			$self->stash( 'full_stack_params', \%p );
			return $self->stash('full_stack_params');
		}
	);
	
	$app->helper(
	    reserved_stash_keywords => sub {
		    my $self = shift;
			return {
			    action            => 1,
				app                => 1,
				cb                  => 1,
				controller       => 1,
				data              => 1,
				extends        => 1,
				format         => 1,
				handler         => 1,
				json             => 1,
				layout           => 1,
				namespace => 1,
				partial         => 1,
				path            => 1,
				status         => 1,
				template     => 1,
				text             => 1,
			};
			return;
		}
	);
	
	$app->helper(
	    is_reserved_stash_keyword => sub {
		    my ( $self, $word ) = @_;
			return 1 if exists $self->reserved_stash_keywords()->{$word};
			return 1 if $word =~ m{\Amojo\.}xms;
			return;
		}
	);
	
	return;
}

1;