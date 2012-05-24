package CogDB::Store::Git;
use Mo 'default';
extends 'CogDB::Store';

use XXX;

use CogDB::CogNode;

use IO::All;

has root => (default => sub {'.'});

sub exists {
    my ($class, $root) = @_;
    return io("$root/node")->exists;
}

sub init {
    my ($class, $root) = @_;
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
        Id => $self->new_id,
        Type => $type,
    );
}

sub put {
    my ($self, $node) = @_;
    $node->Rev($node->Rev + 1);
    $node->Time(scalar time);
    my $text = $node->to_cog;
    io($self->root . "/node/" . $node->Id . "/_")->print($text);
    return 1;
}

sub get {
    my ($self, $id) = @_;
    my $io = io($self->root . "/node/" . $id . "/_");
    return unless $io->exists;
    my $node = CogDB::CogNode->new;
    $node->from_cog($io->all);
    return $node;
}

sub has_id {
    my ($self, $id) = @_;
    my $root = $self->root;
    return -e $self->root . "/node/$id";
}

sub reserve_id {
    my ($self, $id) = @_;
    my $root = $self->root;
    my $file_path = "$root/node/$id/_";
    io($file_path)->assert->print(<<"...");
Id: $id
Rev: 0
...
    return 1;
}

1;
