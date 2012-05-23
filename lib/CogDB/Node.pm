##
# name:      CogDB::Node
# abstract:  CogDB Node Base Class
# author:    Ingy döt Net <ingy@cpan.org>
# license:   perl
# copyright: 2012

package CogDB::Node;
use Mo;

use YAML::XS ();
use JSON::XS ();

has Type => ();
has Id => ();
has Rev => ();
has Time => ();

# TODO this needs to be a bit more Schema driven
sub from_cog {
    my ($self, $text) = @_;
    my ($head, $body) = split "\n\n", $text, 2;
    chomp $head;
    my @head = split "\n", $head;
    for my $header (@head) {
        my ($key, $value) = split /:\s+/, $header, 2;
        my $val = $self->$key;
        if (ref $val eq 'ARRAY') {
            push @$val, $value;
        }
        else {
            $self->$key($value);
        }
    }
    return
}

my $key_order = do {
    my $i = 1;
    +{ map {($_, $i++) } qw(Type Id Rev Time) };
};
sub to_cog {
    my ($self) = @_;
    my @keys = sort {
        my $a_ = $key_order->{$a} || 0;
        my $b_ = $key_order->{$b} || 0;
        $b_ <=> $a_ || $a cmp $b;
    } keys %$self;
    my $cog = '';
    for my $key (@keys) {
        my $value = $self->$key;
        if (ref $value eq 'ARRAY') {
            for my $val (@$value) {
                $cog .= "$key: $val\n";
            }
        }
        else {
            $cog .= "$key: $value\n";
        }
    }
    return $cog;
}

sub from_json {
    my ($self, $json) = @_;
    %$self = (%$self, ${JSON::XS::decode_json($json)});
    return;
}

sub to_json {
    my ($self) = @_;
    return JSON::XS::encode_json($self);
}

sub from_yaml {
    my ($self, $yaml) = @_;
    %$self = (%$self, ${YAML::XS::Load($yaml)});
    return;
}

sub to_yaml {
    my ($self) = @_;
    return YAML::XS::Dump($self);
}

1;
