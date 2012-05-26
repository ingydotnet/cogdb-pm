use Test::More;
use CogDB::Store::Git;
use CogDB::Store::Test;
use XXX;

plan tests => 13;

my $path = './test-store-git-cog';
-e $path and system "rm -r $path";
my $class = CogDB::Store::Git;

my $store = $class->new(root_dir => $path);
is ref($store), $class,
    'Store object created';
is $store->root_dir, $path,
    'root_dir is ok';

ok not($store->exists),
    'not exists';

ok $store->init,
    'init';
ok $store->exists($path),
    'now exists';

$store = CogDB::Store::Git->new(root_dir => $path);
eval { $store->add('myType') };
ok $@,
    "Only CogNodes, for now.";
my $node = $store->add('CogNode');
is $node->Id, 'AAA2',
    'Id is correct';
is $node->Rev, 0,
    'Rev 0';
is $node->Time, undef,
    'Time undef';
my $id = $node->Id;
my $crockford_set = '0-9A-HJKMNP-Z';
like $id, qr/^[$crockford_set]{4}$/,
    'Id pattern';
my $body = <<'...';
I'm here.
Can you not see this?
...
$node->Body($body);
$store->put($node);

my $store2 = $store->get($id);
is $store2->Body, $body,
    'Body retrieve';
ok $node->Time != 0,
    'Time update';
is $node->Rev, 1,
    'Rev bump';

-e $path and system "rm -r $path";
