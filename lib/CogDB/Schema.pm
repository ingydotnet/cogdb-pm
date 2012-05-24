##
# name:      CogDB::Schema
# abstract:  A description of the structure of Cog Nodes
# author:    Ingy döt Net <ingy@cpan.org>
# license:   perl
# copyright: 2012

package CogDB::Schema;
use Mo qw'build xxx';
use IO::All;

has type => ();
has raw => ();

sub BUILD {
    my ($self) = @_;
    my $type = $self->type;
    if ($type !~ /^(Schema|Node|CogNode)$/) {
        die "Schema does not exist";
    }
}

1;
