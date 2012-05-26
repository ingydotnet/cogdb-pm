package CogDB::Store::Git;
use Mo 'default';
extends 'CogDB::Store';

use XXX;

use CogDB::CogNode;

use IO::All;

has root_dir => (default => sub { $ENV{COGDB_ROOT_DIR} || '.' });

# Concept of open vs close is yag for now
# has _opened => (default => sub {0});
# has _closed => (default => sub {0});
# sub is_open { $_[0]->_opened && ! $_[0]->closed };
# sub open { $_->[0]->_opened(1) }
# sub close { $_->[0]->_closed(1) }

sub node_dir { join '/', $_[0]->root_dir, "node" };
sub node_file { join '/', $_[0]->node_dir, $_[1], '_' }
sub exists { return io($_[0]->node_dir)->exists }

sub init {
    my ($self) = @_;
    my $root = $self->root_dir;
    die "Can't init. '$root' is already a CogDB"
        if $self->exists;
    io($root)->mkdir or die
        if not -e $root;
    die "Can't init in non-empty directory $ENV{PWD}"
        unless io($root)->empty;
    io("$root/node")->mkdir or die;
    return 1;
}

sub add {
    my ($self, $type) = @_;
    die "Only CogNodes, for now (type was: $type)"
        if $type ne 'CogNode';
    return CogDB::CogNode->new(
        Id => $self->new_cog_id,
        Type => $type,
    );
}

sub put {
    my ($self, $node) = @_;
    $node->Rev($node->Rev + 1);
    $node->Time(scalar time);
    my $text = $node->to_cog;
    io($self->node_file($node->Id))->print($text);
    return 1;
}

sub get {
    my ($self, $id) = @_;
    my $io = io($self->node_file($id));
    return unless $io->exists;
    my $node = CogDB::CogNode->new;
    $node->from_cog($io->all);
    return $node;
}

sub has_id {
    my ($self, $id) = @_;
    return -e $self->root_dir . "/node/$id";
}

sub reserve_id {
    my ($self, $id) = @_;
    my $file_path = $self->root_dir . "/node/$id/_";
    io($file_path)->assert->print(<<"...");
Id: $id
...
    return 1;
}

1;
