#!/bin/env perl
use strict;
use warnings;
use autodie;

use File::Spec;

use Test2::Bundle::Extended 0.000060;
use Data::Section 0.200006 -setup;        # Set up labeled DATA sections
use File::Temp    qw( tempfile );  #
use File::Slurper 0.009 qw( read_text    );  # Read a file into a string

my $infile  = filename_for('input');

{
    my $outfile = "$infile.nick_site.counts";
    system(File::Spec->catfile('bin', 'count_nicks') .  " $infile");
    my $result   = read_text $outfile;
    my $expected = string_from('expected');
    is( $result, $expected, 'nick sites correctly tabulated' );

    my $second_outfile = "$infile.nick_site.fr_secondstrand.counts";
    my $second_result = read_text $second_outfile;
    my $second_expected = string_from('expected_second');

    is ( $second_result, $second_expected, 'nick sites for case of fr_secondstrand are correct');

    unlink $outfile;
    unlink $second_outfile;
}

{
    my $outfile = "$infile.nick_site.counts";
    system(File::Spec->catfile('bin', 'count_nicks') .  " $infile 16 0");
    my $result   = read_text $outfile;
    my $expected = string_from('expected_swapped');
    is( $result, $expected, 'nick sites correct for explicitly set forward and reverse values opposite of the default');

    unlink $outfile;
}
unlink $infile;

done_testing;

sub sref_from {
    my $section = shift;

    #Scalar reference to the section text
    return __PACKAGE__->section_data($section);
}


sub string_from {
    my $section = shift;

    #Get the scalar reference
    my $sref = sref_from($section);

    #Return a string containing the entire section
    return ${$sref};
}

sub fh_from {
    my $section = shift;
    my $sref    = sref_from($section);

    #Create filehandle to the referenced scalar
    open( my $fh, '<', $sref );
    return $fh;
}

sub assign_filename_for {
    my $filename = shift;
    my $section  = shift;

    # Don't overwrite existing file
    die "'$filename' already exists." if -e $filename;

    my $string   = string_from($section);
    open(my $fh, '>', $filename);
    print {$fh} $string;
    close $fh;
    return;
}

sub filename_for {
    my $section           = shift;
    my ( $fh, $filename ) = tempfile();
    my $string            = string_from($section);
    print {$fh} $string;
    close $fh;
    return $filename;
}

sub temp_filename {
    my ($fh, $filename) = tempfile();
    close $fh;
    return $filename;
}

sub delete_temp_file {
    my $filename  = shift;
    my $delete_ok = unlink $filename;
    ok($delete_ok, "deleted temp file '$filename'");
}


#------------------------------------------------------------------------
# IMPORTANT!
#
# Each line from each section automatically ends with a newline character
#------------------------------------------------------------------------

__DATA__
__[ input ]__
read_0	0	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	@@DDBHHCC<EHHHGGHIIIHIIIFHEGFHIIHFHHHHHIIIIIHGHFEH	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_1	0	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	DDDDDIIHIIIIIIHIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_2	0	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	DB?@DGDEEHHHIFCCEHHIIIIIIIEHHHHIHEHIIIIIIIIIIIIGIH	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_3	0	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	DDDDDIIHHIIIIIIIIIIIIIIIIIIIIIIHIIIIIIIIIIIIIIIIII	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_4	0	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	@DBD?ECDGEH@EEHHEHH@GGHEGHHIHCHHIGHHEHHGHHIIEEHHHH	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_5	16	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	DCDDDIIIHIIIIIHHIIIIIIIIHIIHIHIIIHIIHIIIIIIIIIIIII	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_6	0	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	DDDDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_7	16	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	DBD@<<EEHIG1E@CECC@GEHHIGH@HEEH?CHHIHGHF1DCHHI1CGC	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_8	0	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	DDDDDIIHHIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_9	0	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	DDDDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIHIIHHIIIIIIII	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_10	16	gi|4927719|gb|AF125673.1|	7805	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	DDDDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIHIIHHIIIIIIII	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
read_11	0	gi|4927719|gb|AF125673.1|	7855	50	50M	*	0	0	CAAACCGTTTTGGGTTACACATTTACAAGCAACTTATATAATAATACTAA	DDDDDIIHIIIIIIHIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	AS:i:0	XN:i:0	XM:i:0	XO:i:0	XG:i:0	NM:i:0	MD:Z:50	YT:Z:UU	NH:i:1
__[ expected ]__
position	forward	reverse	for_RPM	rev_RPM
7804	0	0	0	0
7854	9	0	750000	0
7855	0	1	0	83333
7905	0	2	0	166666
__[ expected_second ]__
position_fr_secondstrand	forward	reverse	for_RPM	rev_RPM
7804	1	0	83333	0
7854	2	0	166666	0
7855	0	0	0	0
7905	0	9	0	750000
__[ expected_swapped ]__
position	forward	reverse	for_RPM	rev_RPM
7804	1	0	83333	0
7854	2	0	166666	0
7855	0	0	0	0
7905	0	9	0	750000
