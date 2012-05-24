package t::Mock;
use Test::MockObject;
my $mock = Test::MockObject->new;

our @hist;
sub generic_mock {
    my ($name, $args) = @_; # TODO: Make a thing that dedups the $name
    push @hist, [ $name => $args ];
}

sub import {
    my ($class, $fake_module, %methods) = @_;
    $methods{new} = sub { bless {}, $fake_module }
        unless exists $methods{new};
    $mock->fake_module($fake_module, %methods);
}
1;
