###############################################################################
#
# Tests for Excel::Writer::XLSX::Chart methods.
#
# Copyright 2000-2023, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions '_new_object';
use strict;
use warnings;
use Excel::Writer::XLSX::Chart::Bar;

use Test::More tests => 1;


###############################################################################
#
# Tests setup.
#
my $expected;
my $got;
my $caption;
my $chart;


###############################################################################
#
# Test the _write_bar_dir() method.
#
$caption  = " \tChart: _write_bar_dir()";
$expected = '<c:barDir val="bar"/>';

$chart = _new_object( \$got, 'Excel::Writer::XLSX::Chart::Bar' );

$chart->_write_bar_dir();

is( $got, $expected, $caption );

__END__


