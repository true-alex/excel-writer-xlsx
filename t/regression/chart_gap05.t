###############################################################################
#
# Tests the output of Excel::Writer::XLSX against Excel generated files.
#
# Copyright 2000-2023, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions qw(_compare_xlsx_files _is_deep_diff);
use strict;
use warnings;

use Test::More tests => 1;

###############################################################################
#
# Tests setup.
#
my $filename     = 'chart_gap05.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members  = [];
my $ignore_elements = {
    'xl/charts/chart1.xml' => ['<c:pageMargins'],
    'xl/workbook.xml'      => [ '<fileVersion' ],
};


###############################################################################
#
# Test the creation of a simple Excel::Writer::XLSX file.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();
my $chart     = $workbook->add_chart(type  => 'bar', embedded => 1);

# For testing, copy the randomly generated axis ids in the target xlsx file.
$chart->{_axis_ids}  = [ 45938176, 59715584 ];
$chart->{_axis2_ids} = [ 70848512, 54519680 ];

my $data = [ [ 1, 2, 3, 4, 5 ],
             [ 6, 8, 6, 4, 2 ], ];

$worksheet->write( 'A1', $data );

$chart->add_series( values => '=Sheet1!$A$1:$A$5', gap => 51, overlap => 12 );
$chart->add_series( values => '=Sheet1!$B$1:$B$5', y2_axis => 1, gap => 251, overlap => -27 );

$chart->set_x2_axis( label_position => 'next_to' );

$worksheet->insert_chart( 'E9', $chart );

$workbook->close();


###############################################################################
#
# Compare the generated and existing Excel files.
#

my ( $got, $expected, $caption ) = _compare_xlsx_files(

    $got_filename,
    $exp_filename,
    $ignore_members,
    $ignore_elements,
);

_is_deep_diff( $got, $expected, $caption );


###############################################################################
#
# Cleanup.
#
unlink $got_filename;

__END__
