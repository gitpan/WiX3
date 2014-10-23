package WiX3::XML::Fragment;

use 5.008001;

# Must be done before Moose, or it won't get picked up.
use metaclass (
	metaclass   => 'Moose::Meta::Class',
	error_class => 'WiX3::Util::Error',
);
use Moose;
use WiX3::Util::StrictConstructor;

our $VERSION = '0.009';
$VERSION =~ s/_//ms;

# http://wix.sourceforge.net/manual-wix3/wix_xsd_fragment.htm

with 'WiX3::Role::Traceable';
with 'WiX3::XML::Role::Fragment';
with 'WiX3::XML::Role::TagAllowsChildTags';

#####################################################################
# Main Methods

sub BUILDARGS {
	my $class = shift;

	if ( @_ == 1 && !ref $_[0] ) {
		return { id => $_[0] };
	} elsif ( @_ == 1 && 'HASH' eq ref $_[0] ) {
		return $_[0];
	} else {
		my %hash = @_;
		return \%hash;
	}

	return;
} ## end sub BUILDARGS

#####################################################################
# Methods to implement the Tag role.

sub as_string {
	my $self = shift;

	my @namespaces   = $self->get_namespaces();
	my $namespaces   = join q{ }, @namespaces;
	my $id           = 'Fr_' . $self->get_id();
	my $child_string = q{};
	$child_string = $self->indent( 2, $self->as_string_children() )
	  if $self->has_child_tags();
	chomp $child_string;

	return <<"EOF";
<?xml version='1.0' encoding='windows-1252'?>
<Wix $namespaces>
  <Fragment Id='$id'>
$child_string
  </Fragment>
</Wix>
EOF
} ## end sub as_string

sub get_namespace {
	return q{xmlns='http://schemas.microsoft.com/wix/2006/wi'};
}

#####################################################################
# Methods to implement the Tag role.

# Unless this method is overwritten, this fragment does not need
# to regenerate itself before the .msi/.msm is built.

sub regenerate {
	return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

WiX3::XML::Fragment - Default fragment code.

=head1 VERSION

This document describes WiX3::XML::Fragment version 0.009

=head1 SYNOPSIS

	my $fragment = WiX3::XML::Fragment(
		id => $id,
	);
  
=head1 DESCRIPTION

This module defines a default fragment.

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

L<Exception::Class|Exception::Class>

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

