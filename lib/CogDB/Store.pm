##
# This should be a Store base class.
# Subclasses should be:
# - CogDB::Store::Local
# - CogDB::Store::Remote
# Or maybe more to the point:
# - CogDB::Store::Git
# - CogDB::Store::RestClient

package CogDB::Store;
use Mo 'default';
use Convert::Base32::Crockford 0.11 ();

srand();

my $test_id = "AAA2";
sub new_id {
    my $self = shift;
    while (1) {
        # Base32 125bit random number.
        my $id = $ENV{COGDB_TEST_MODE} ? $test_id++ :
            uc Convert::Base32::Crockford::encode_base32(
                join "", map { pack "S", int(rand(65536)) } 1..2
            ); 
        $id = substr($id, 0, 4);
        next unless $id =~ /[A-Z]/ and $id =~ /[2-9]/;
        next if $self->has_id($id);
        $self->reserve_id($id);
        return $id;
    }
}

1;
