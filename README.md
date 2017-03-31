# NAME

Bio::IRCF::CountNicks

# DESCRIPTION

Tabulate single-strand nicks. This assumes that double stranded DNA (dsDNA) was nicked, that the strands were separated and sequenced. Strand-specific sequencing is assumed. We believe these are of the library type "fr-firststrand", but just in case, we also produce a "fr-secondstrand" version. Either way, the original sequence represented by the FASTQ reads represents the nucleotides just 3' from the nicked nucleotide, which was eliminated by the nicking.

# SYNOPSIS

    count_nicks filename.sam

Given a SAM file called "filename.sam", this will create two output files:

- `filename.sam.nick_site.counts` (assumes library type "fr\_firststrand", i.e. that the FASTQ file contains reads of the same strand as the nicked DNA, starting just 3' of the nick.
- `filename.sam.nick_site.fr_secondstrand.counts` (assumes library type "fr\_secondstrand", i.e. that the FASTQ file contains reads of the opposite strand as the nicked DNA.

# INSTALLATION

It is probably best to install App::cpanminus first:

    cpan App::cpanminus

When it asks you configuration questions, just keep hitting ENTER. From now on, you can almost always use `cpanm` isntead of `cpan` for installing modules. If you have problems, see the [cpanm documentation](https://metacpan.org/pod/App::cpanminus).

Then download the [latest CountNicks tarball](https://github.com/MU-IRCF/Bio-IRCF-CountNicks/raw/master/current_distribution/Bio-IRCF-CountNicks.tar.gz).

Then install it using cpanm:

    cpanm Bio-IRCF-CountNicks.tar.gz

If you have any problems installing it, please contact the author directly or [file an issue](https://github.com/MU-IRCF/Bio-IRCF-CountNicks/issues/new).

# DIAGNOSTICS

    A warining is thrown for any SAM flag besides '0' or '16' and that line of
    the SAM file is skipped.

# INCOMPATIBILITIES

    None known

# BUGS AND LIMITATIONS

    Currently this module only recognizes the SAM flags '0' (forward reads) and '16' (reverse reads).

    There are no known bugs in this module.
    Please report problems to the author.
    Patches are welcome.

# DEPENDENCIES

Runtime requires

    Perl 5.10.1 or later

    List::MoreUtils

Tests require

    Test2::Bundle::Extended
    Data::Section
    File::Slurper

# First-time Perl installation on Windows

## Strawberry Perl (MSI version)

Strawberry Perl is a completely free distribution of Perl for Windows. To install it:

- Download the recommend version from the home page (e.g. http://strawberryperl.com/download/5.24.1.1/strawberry-perl-5.24.1.1-64bit.msi).
- After it finishes downloading, double click on it and follow the installation instructions that it gives you.

## Strawberry Perl (if you cannot install the MSI)

- Create a directory (something like C:\\Users\\username\\Strawberry).
- Then download the latest "portable" version of [Strawberry Perl](http://strawberyperl.com).
- Unzip it in the newly created directory.
- Now you can run "portableshell.bat" to open a new Window in which Perl is available. After that, follow the normal module installation instructions above.

## ActiveState Perl

[ActiveState Perl](http://www.activestate.com/activeperl/downloads) is another distribution of Perl for Windows.
