use Test::More;
use CogDB::Store::Git;

my $path = './foo-cog';
-e $path and system "rm -r $path";
my $class = CogDB::Store::Git;
ok not($class->exists($path)), 'not exists';
ok $class->init($path), 'init';
ok $class->exists($path), 'now exists';
pass;done_testing;exit 0; #-------------------------------------------

my $store = CogDB::Store::Git->new(root => './foo-cog');
is ref($store), 'CogDB::Store',
    "Store object is generic";

my $node = $store->add('CogNode');
is $node->Rev, 0, 'Rev';
is $node->Time, 0, 'Time';
my $id = $node->Id;
like $id, qr/^\d{4}-\d{475}$/, 'Id pattern';
my $body = <<'...';
I'm here.
Can you not see this?
...
$node->Body($body);
$store->put($node);

my $store2 = $store->get($id);
is $store2->Body, $body, 'Body retrieve';
is_not $node->Time, 0, 'Time update';
is $node->Rev, 1, 'Rev bump';

plan;
