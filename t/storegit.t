use Test::More;
use CogDB::Store::Git;
use XXX;

$ENV{COGDB_TEST_MODE} = 1;

my $path = './foo-cog';
-e $path and system "rm -r $path";
my $class = CogDB::Store::Git;
ok not($class->exists($path)), 'not exists';
ok $class->init($path), 'init';
ok $class->exists($path), 'now exists';

my $store = CogDB::Store::Git->new(root => './foo-cog');
eval { $store->add('myType') }; ok $@, "Only CogNodes, for now.";
my $node = $store->add('CogNode');
is $node->Rev, 0, 'Rev 0';
is $node->Time, undef, 'Time undef';
my $id = $node->Id;
my $crockford_set = '0-9A-HJKMNP-Z';
like $id, qr/^[$crockford_set]{4}$/, 'Id pattern';
my $body = <<'...';
I'm here.
Can you not see this?
...
$node->Body($body);
$store->put($node);

my $store2 = $store->get($id);
is $store2->Body, $body, 'Body retrieve';
ok $node->Time != 0, 'Time update';
is $node->Rev, 1, 'Rev bump';

done_testing;

-e $path and system "rm -r $path";
