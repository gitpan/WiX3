package WiX3::XML::WixVariable;

use 5.008001;

# Must be done before Moose, or it won't get picked up.
use metaclass (
	metaclass   => 'Moose::Meta::Class',
	error_class => 'WiX3::Util::Error',
);
use Moose;
use Params::Util qw( _STRING  );
use MooseX::Types::Moose qw( Str );
use WiX3::Util::StrictConstructor;
use WiX3::Types qw( YesNoType );

our $VERSION = '0.010';
$VERSION =~ s/_//ms;

## No children allowed.
with 'WiX3::XML::Role::Tag';

# http://wix.sourceforge.net/manual-wix3/wix_xsd_wixvariable.htm

#####################################################################
# Accessors

has id => (
	is       => 'ro',
	isa      => Str,
	reader   => 'get_id',
	required => 1,
);

has overridable => (
	is      => 'ro',
	isa     => YesNoType,
	reader  => '_get_overridable',
	default => undef,
	coerce  => 1,
);

has value => (
	is       => 'ro',
	isa      => Str,
	reader   => '_get_value',
	required => 1,
);

#####################################################################
# Methods to implement the Tag role.

sub as_string {
	my $self = shift;

	# Print tag.
	my $string = '<WixVariable';

	my @attribute = (
		[ 'Id'          => $self->get_id(), ],
		[ 'Overridable' => $self->_get_overridable(), ],
		[ 'Value'       => $self->_get_value(), ],
	);

	my ( $k, $v );

	foreach my $ref (@attribute) {
		( $k, $v ) = @{$ref};
		$string .= $self->print_attribute( $k, $v );
	}

	$string .= qq{ />\n};

	return $string;
} ## end sub as_string

sub get_namespace {
	return q{xmlns='http://schemas.microsoft.com/wix/2006/wi'};
}

no Moose;
__PACKAGE__->meta()->make_immutable();

1;

__END__

=head1 NAME

WiX3::XML::WixVariable - Defines a WixVariable tag.

=head1 VERSION

This document describes WiX3::XML::WixVariable version 0.010

=head1 SYNOPSIS

TODO
  
=head1 DESCRIPTION

TODO

=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

TODO

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-wix3@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Curtis Jewell  C<< <csjewell@cpan.org> >>

=head1 SEE ALSO

L<http://wix.sourceforge.net/>

=head1 LICENCE AND COPYRIGHT

Copyright 2009, 2010 Curtis Jewell C<< <csjewell@cpan.org> >>.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl 5.8.1 itself. See L<perlartistic|perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

