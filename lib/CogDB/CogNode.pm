##
# name:      CogDB::CogNode
# abstract:  CogDB CogNode Object Class
# author:    Ingy döt Net <ingy@cpan.org>
# license:   perl
# copyright: 2012

package CogDB::CogNode;
use Mo;
extends 'CogDB::Node';

has Tags => (default => sub { [] });
has Urls => (default => sub { [] });
has Body => ();

1;
