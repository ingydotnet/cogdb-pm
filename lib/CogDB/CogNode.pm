##
# name:      CogDB::CogNode
# abstract:  CogDB CogNode Object Class
# author:    Ingy döt Net <ingy@cpan.org>
# license:   perl
# copyright: 2012

package CogDB::CogNode;
use Mo;
use CogDB::Node;
extends 'CogDB::Node';

has Tag => (default => sub { [] });
has Url => (default => sub { [] });
has Body => ();

1;
