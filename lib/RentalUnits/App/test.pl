#! /usr/bin/perl

#package RentalUnits::App::Test;

use Mojolicious::Controller;
use Mojolicious::Routes;
use Mojolicious::Routes::Match;


# Routes
my $r = Mojolicious::Routes->new;
#$r->get('/:controller/:action')->to();
#$r->put('/:controller/:action');

$r->get('/application/:id')->to(
    controller => 'Application',
    action     => 'get_application',
    validation_class => 'RentalUnits::Validation::Application',
  );

# Match
my $c = Mojolicious::Controller->new;
#my $c2 = Mojolicious::Controller->new;
my $match = Mojolicious::Routes::Match->new(root => $r);
#$match->match();
$match->match($c => {method => 'GET', path => '/application/bar'});


#$match->match($c2 => {method => 'GET', path => '/abc/xyz'});


print "controller 1: " . $match->stack->[0]{controller} . "\n";
print "id 1: " . $match->stack->[0]{id} . "\n";
print "action 1: " . $match->stack->[0]{action} . "\n";
print "validation_class 1: " . $match->stack->[0]{validation_class} . "\n";

#print "controller 2: " . $match->stack->[1]{controller} . "\n";
#print "action 2: " . $match->stack->[1]{action} . "\n";

# Render
print $match->path_for . "\n";
print $match->path_for(action => 'baz') . "\n";


