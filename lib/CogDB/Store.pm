##
# name:      CogDB::
# abstract:  CogDB Storage Engine Base Class
# author:    Ingy döt Net <ingy@cpan.org>
# license:   perl
# copyright: 2012

package CogDB::Store;
use Mo;
use Convert::Base32::Crockford;

use XXX;

srand();

sub new_cog_id {
    my $self = shift;
    while (1) {
        my $id = $self->new_id(4);
        next unless $id =~ /[A-Z]/ and $id =~ /[2-9]/;
        next if $self->has_id($id);
        $self->reserve_id($id);
        return $id;
    }
}

sub new_id {
    my ($self, $length) = @_;
    my $times = int($length * 5 / 16) + 1;
    my $id = Convert::Base32::Crockford::encode_base32(
        join "", map { pack "S", int(rand(65536)) } 1..$times
    ); 
    return substr($id, 0, $length);
}

1;
