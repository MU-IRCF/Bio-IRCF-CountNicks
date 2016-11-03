#!/bin/env perl
use strict;
use warnings;
use autodie;

use File::Spec;
use File::Basename;
use FindBin qw($Bin);

use Test2::Bundle::Extended 0.000060;
use Data::Section           0.200006 -setup;        # Set up labeled DATA sections
use File::Temp                       qw( tempfile ); 
use File::Slurper           0.009    qw( read_text write_text );

# Create input file (and give it a temp name)
my $infile  = filename_for('input');

# Get Count Nicks executable name
my $count_nicks = File::Spec->catfile('bin', 'count_nicks');

# Test using default values
{
    my $outfile = "$infile.nick_site.counts";
    system("perl $Bin/../lib/Bio/IRCF/CountNicks.pm $infile");
    my $result   = unix_read($outfile);
    my $expected = string_from('expected');
    is($result, $expected, 'nick sites correctly tabulated' );

    my $second_outfile = "$infile.nick_site.fr_secondstrand.counts";
    my $second_result = unix_read($second_outfile);
    my $second_expected = string_from('expected_second');

    is($second_result, $second_expected, 'nick sites for case of fr_secondstrand are correct');

    unlink $outfile;
    unlink $second_outfile;
}

# Test using values opposite of default
{
    my $outfile = "$infile.nick_site.counts";
    system("perl $Bin/../lib/Bio/IRCF/CountNicks.pm $infile 16 0");
    my $result   = unix_read($outfile);
    my $expected = string_from('expected_swapped');
    is($result, $expected, 'nick sites correct for explicitly set forward and reverse values opposite of the default');

    unlink $outfile;

    # Clean up other results (that we didn't test)
    my $second_outfile = "$infile.nick_site.fr_secondstrand.counts";
    unlink $second_outfile;
}

# Remove input test file
unlink $infile;

done_testing;

sub string_from {
    my $section = shift;

    #Get the scalar reference
    my $sref = __PACKAGE__->section_data($section);

    my $string = "$$sref";

    # # Make all line endings like UNIX
    # $string =~ s/\R/\n/g;

    #Return a string containing the entire section
    return $string;
}

sub filename_for {
    my $section   = shift;
    my $filename  = temp_filename();
    my $content   = string_from($section);

    write_text($filename, $content);
    return $filename;
}

sub temp_filename {

    # use tempfile function just to get a random filename
    my ($fh, $filename) = tempfile();
    close $fh;
    my $basename = basename($filename);

    # Delete temp file
    unlink $filename;

    # Return random filename
    return $basename;
}

sub convert_to_unix_newlines {
    my $string = shift;

    $string =~ s/\R/\n/g;
    return $string;
}

# Read in file and convert line endings to Unix line endings (helps tests pass)
sub unix_read {
    my $filename = shift;

    my $content = read_text($filename);

    my $unix_style_content = convert_to_unix_newlines($content); 

    return $unix_style_content;
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
