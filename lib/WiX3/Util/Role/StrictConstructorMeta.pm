package                                # Hide from PAUSE.
  WiX3::Util::Role::StrictConstructorMeta;

use 5.008001;
use strict;
use warnings;
use Moose::Role;
use WiX3::Exceptions;

our $VERSION = '0.007';
$VERSION = eval $VERSION; ## no critic(ProhibitStringyEval)

around '_generate_BUILDALL' => sub {
	my $orig = shift;
	my $self = shift;

	my $source = $self->$orig();
	$source .= ";\n" if $source;

	my @attrs = (
		map  {"$_ => 1,"}
		grep {defined}
		map  { $_->init_arg() } @{ $self->_attributes() } );

	$source .= <<"EOF";
my \%attrs = (@attrs);

my \@bad = sort grep { ! \$attrs{\$_} }  keys \%{ \$params };

if (\@bad) {
    WiX3::Exception::Parameter->throw("Found unknown attribute(s) passed to the constructor: \@bad");
}
EOF

	return $source;
};

no Moose::Role;

1;
