use t::Setup;
use TestML -run;

sub run {
    my $command = (shift)->value;
    system($command);
}

sub check_manifest {
    my $list = (shift)->list->value;
    for my $string (@$list) {
        my $path = $string->value;
        die "'$path' does not exist" unless -e $path;
    }
    return 1;
}

__DATA__
%TestML 1.0

test = (command, manifest) {
    command.run();
    manifest.Lines().check_manifest.OK();
};

test(*command, *manifest);

=== Init command
--- command: cogdb init
--- manifest
.git
node
index
index/Name
index/Schema
