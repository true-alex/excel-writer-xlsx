package Excel::XLSX::Writer::Container::Relationships;

###############################################################################
#
# Relationships - A class for writing the Excel XLSX Rels file.
#
# Used in conjunction with Excel::XLSX::Writer
#
# Copyright 2000-2010, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

# perltidy with the following options: -mbl=2 -pt=0 -nola

use 5.010000;
use strict;
use warnings;
use Exporter;
use Carp;
use XML::Writer;

our @ISA     = qw(Exporter);
our $VERSION = '0.01';

our $package_schema =
  'http://schemas.openxmlformats.org/package/2006/relationships';
our $document_schema =
  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/';

###############################################################################
#
# Public and private API methods.
#
###############################################################################


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;

    my $self = {
        _writer => undef,
        _rels   => [],
        _id     => 1,
    };

    bless $self, $class;

    return $self;
}


###############################################################################
#
# _assemble_xml_file()
#
# Assemble and write the XML file.
#
sub _assemble_xml_file {

    my $self = shift;

    return unless $self->{_writer};

    $self->_write_xml_declaration;
    $self->_write_relationships();
}


###############################################################################
#
# _set_xml_writer()
#
# Set the XML::Writer for the object.
#
sub _set_xml_writer {

    my $self     = shift;
    my $filename = shift;

    my $output = new IO::File( $filename, 'w' );
    my $writer = new XML::Writer( OUTPUT => $output );

    $self->{_writer} => $writer;
}


###############################################################################
#
# _add_relationship()
#
# Add container relationship to XLSX .rels xml files.
#
sub _add_relationship {

    my $self   = shift;
    my $type   = shift;
    my $target = shift // $type;

    $type   = $document_schema . $type;
    $target = $target . '.xml';

    push @{ $self->{_rels} }, [ $type, $target ];
}


###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_xml_declaration()
#
# Write the XML declaration.
#
sub _write_xml_declaration {

    my $self       = shift;
    my $writer     = $self->{_writer};
    my $encoding   = 'UTF-8';
    my $standalone = 1;

    $writer->xmlDecl( $encoding, $standalone );
}


##############################################################################
#
# _write_relationships()
#
# Write the <Relationships> element.
#
sub _write_relationships {

    my $self = shift;

    my @attributes = ( 'xmlns' => $package_schema, );

    $self->{_writer}->startTag( 'Relationships', @attributes );

    for my $rel ( @{ $self->{_rels} } ) {
        $self->_write_relationship( @$rel );
    }

    $self->{_writer}->endTag( 'Relationships' );
}


##############################################################################
#
# _write_relationship()
#
# Write the <Relationship> element.
#
sub _write_relationship {

    my $self   = shift;
    my $type   = shift;
    my $target = shift;

    my @attributes = (
        'Id'     => 'rId' . $self->{_id}++,
        'Type'   => $type,
        'Target' => $target,
    );

    $self->{_writer}->emptyTag( 'Relationship', @attributes );
}


1;


__END__

=pod

=head1 NAME

Relationships - A class for writing the Excel XLSX Rels file.

=head1 SYNOPSIS

See the documentation for L<Excel::XLSX::Writer>.

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::XLSX::Writer>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

� MM-MMX, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

=head1 LICENSE

Either the Perl Artistic Licence L<http://dev.perl.org/licenses/artistic.html> or the GPL L<http://www.opensource.org/licenses/gpl-license.php>.

=head1 DISCLAIMER OF WARRANTY

See the documentation for L<Excel::XLSX::Writer>.

=cut