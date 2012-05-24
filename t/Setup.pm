package t::Setup;
use strict;
use Cwd;
use File::Path;

my $test_dir;
BEGIN {
    $ENV{COGDB_TEST_MODE} = 1;
    $test_dir = Cwd::abs_path('test-cog');
    File::Path::rmtree($test_dir) if -d $test_dir;
    mkdir $test_dir;
    chdir $test_dir or die;
}

END {
    chdir '..';
    File::Path::rmtree($test_dir);
}

1;
