package CogDB::Store::Test;
package CogDB::Store;

use strict;

my $test_id = "AAA2";
sub new_id {
    my ($self, $length) = @_;
    if ($length == 4) {
        return $test_id++;
    }
    elsif ($length == 25) {
        return "T35TT35TT35TT35TT35TC0GDB";
    }
    else {
        die "Unknown test id length: $length";
    }
}

1;
