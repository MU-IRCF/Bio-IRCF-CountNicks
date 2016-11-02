#!/bin/env perl
package Bio::IRCF::CountNicks;
# ABSTRACT: Count DNA nicks in a SAM file, assuming that the start of each original sequence read occurred just 3' to the nick.

#=============================================================================
# STANDARD MODULES AND PRAGMAS
use v5.10.1;  # Require at least Perl version 5.10.1
use strict;   # Must declare all variables before using them
use warnings; # Emit helpful warnings
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. open)

use List::MoreUtils qw( uniq );
use List::Util qw( max );

my $FORWARD_FLAG = 0;
my $REVERSE_FLAG = 16;

main(@ARGV) unless caller();

sub main
{
    my $sam_file     = shift;
    my $forward_flag = shift // $FORWARD_FLAG;
    my $reverse_flag = shift // $REVERSE_FLAG;

    # check to make sure that forward and reverse flags are not identical
    die "Forward and reverse flags cannot be identical!\n" if $forward_flag == $reverse_flag;

    # Create file handle for SAM file
    open(my $fh_sam, '<', $sam_file);

    # create output file handles
    open(my $fh_out,        '>', "$sam_file.nick_site.counts");
    open(my $fh_out_second, '>', "$sam_file.nick_site.fr_secondstrand.counts");

    # Print header
    print {$fh_out} "position\tforward\treverse\tfor_RPM\trev_RPM\n";
    print {$fh_out_second} "position_fr_secondstrand\tforward\treverse\tfor_RPM\trev_RPM\n";

    my %forward_nicks_at;
    my %reverse_nicks_at;
    my %second_forward_nicks_at;
    my %second_reverse_nicks_at;
    my $total_reads = 0;

    my $max_position = 0;

    while (my $line = readline $fh_sam)
    {
        my ($flag, $ref_seq_name, $pos, $seq) = (split /\t/, $line)[1,2,3,9];

        $max_position = max($pos, $max_position);

        my $reference_five_prime_pos  = $pos -1;
        my $reference_three_prime_pos = $pos + length($seq);

        if ($flag eq $forward_flag)
        {
            # The position from the SAM file is the nucletodie AFTER the nick.
            # The "nicked" nucleotide was obliterated, so the nick is the
            # nucleotide just 5' to this position. (A pos of 10 means the
            # nick was at position 9).
            $forward_nicks_at{$reference_five_prime_pos}++;

            # For fr_secondstrand, this would be the equivalent of the reverse flag
            $second_reverse_nicks_at{$reference_three_prime_pos}++;
        }
        elsif ($flag eq $reverse_flag )
        {
            # Note that this position is in the reference frame of the forward strand
            # Assuming that the position is 10 and the length of the read is 10, then
            # the last base of this read would be at position 19 (in the reference frame).
            # However, position 19 represents the first base after the nick, which would be at position 20.
            $reverse_nicks_at{$reference_three_prime_pos}++;

            # For fr_secondstrand, this would be the equivalent of the forward flag
            $second_forward_nicks_at{$reference_five_prime_pos}++;
        }
        else
        {
            warn "Flag '$flag' not handled";
        }

        $total_reads++;
    }

    # Close SAM file handle
    close($fh_sam);

    # We're using positions from both to make comparisons between the two easier
    my @positions = uniq (sort { $a <=> $b} (keys %forward_nicks_at, keys %reverse_nicks_at, keys %second_forward_nicks_at, keys %second_reverse_nicks_at));

    for my $position (@positions)
    {

        # For the case of fr_firststrand
        {
            my $count_for = $forward_nicks_at{$position} // 0;
            my $count_rev = $reverse_nicks_at{$position} // 0;
            my $perc_for = sprintf( '%d', $count_for * 1000000 / $total_reads);
            my $perc_rev = sprintf( '%d', $count_rev * 1000000 / $total_reads);
            print {$fh_out} "$position\t$count_for\t$count_rev\t$perc_for\t$perc_rev\n";
        }

        # For the case of fr_secondstrand
        {
            my $count_for = $second_forward_nicks_at{$position} // 0;
            my $count_rev = $second_reverse_nicks_at{$position} // 0;
            my $perc_for = sprintf( '%d', $count_for * 1000000 / $total_reads);
            my $perc_rev = sprintf( '%d', $count_rev * 1000000 / $total_reads);
            print {$fh_out_second} "$position\t$count_for\t$count_rev\t$perc_for\t$perc_rev\n";
        }
    }

    # Close output file handles
    close($fh_out);
    close($fh_out_second);
}

1;  #Modules must return a true value

=pod


=head1 Bio::IRCF::CountNicks

Tabulate single-strand nicks. This assumes that double stranded DNA (dsDNA) was nicked, that the strands were separated and sequenced. Strand-specific sequencing is assumed. We believe these are of the library type "fr-firststrand", but just in case, we also produce a "fr-secondstrand" version. Either way, the original sequence represented by the FASTQ reads represents the nucleotides just 3' from the nicked nucleotide, which was eliminated by the nicking.

=head1 SYNOPSIS

    count_nicks filename.sam

Given a SAM file called "filename.sam", this will create two output files:

=over 4

=item *

C<filename.sam.nick_site.counts> (assumes library type "fr_firststrand", i.e. that the FASTQ file contains reads of the same strand as the nicked DNA, starting just 3' of the nick.

=item *

C<filename.sam.nick_site.fr_secondstrand.counts> (assumes library type "fr_secondstrand", i.e. that the FASTQ file contains reads of the opposite strand as the nicked DNA.

=back

=head1 INSTALLATION

It is probably best to install App::cpanminus first:

    cpan App::cpanminus

When it asks you configuration questions, just keep hitting ENTER. From now on, you can almost always use C<cpanm> isntead of C<cpan> for installing modules. If you have problems, see the L<cpanm documentation|https://metacpan.org/pod/App::cpanminus>.

Then download the L<latest CountNicks tarball|https://github.com/MU-IRCF/CountNicks/raw/master/dists/CountNicks-0.0011.tar.gz>.

Then install it using cpanm:

    cpanm CountNicks-0.0011.tar.gz

If you have any problems installing it, please contact the author directly or L<file an issue|https://github.com/MU-IRCF/CountNicks/issues/new>.

=head1 DIAGNOSTICS

    A warining is thrown for any SAM flag besides '0' or '16' and that line of
    the SAM file is skipped.

=head1 INCOMPATIBILITIES

    None known

=head1 BUGS AND LIMITATIONS

    Currently this module only recognizes the SAM flags '0' (forward reads) and '16' (reverse reads).

    There are no known bugs in this module.
    Please report problems to the author.
    Patches are welcome.

=head1 DEPENDENCIES

Runtime requires

    Perl 5.10.1 or later

    List::MoreUtils

Tests require

    Test2::Bundle::Extended
    Data::Section
    File::Slurper

=head1 First-time Perl installation on Windows

=head2 Strawberry Perl

Strawberry Perl is a completely free distribution of Perl for Windows. To install it:

=over 4

=item *

Create a directory (something like C:\Users\username\Strawberry).

=item *

Then download the latest "portable" version of L<Strawberry Perl|http://strawberyperl.com>.

=item *

Unzip it in the newly created directory.

=item *

Now you can run "portableshell.bat" to open a new Window in which Perl is available. After that, follow the normal module installation instructions above.

=back

=head2 ActiveState Perl

L<ActiveState Perl|http://www.activestate.com/activeperl/downloads> is another distribution of Perl for Windows.

=cut
