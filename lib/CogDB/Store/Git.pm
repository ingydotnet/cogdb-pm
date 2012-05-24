package CogDB::Store::Git;
use Mo 'default';
use IO::All;

has root => (default => sub {'.'});
has node_path => (default => sub {
    my $self = shift;
    $self->root . "/node"
});

sub exists {
    my ($self, $root) = @_;
    io("$root/node")->exists;
}

sub init {
    my ($self, $root) = @_;
    io($root)->mkdir or die;
    io("$root/node")->mkdir or die;
}

sub nickname {
    my ($self, %args) = @_;
    io($args{new})->symlink($args{orig});
}

sub has_key {
    my ($self, $id) = @_;
    -e $id
}
