# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.012.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Count DNA nicks in a SAM file, assuming that the start of each original sequence read occurred just 3' to the nick.",
  "AUTHOR" => "Christopher Bottoms <molecules <at> cpan <dot> org>",
  "BUILD_REQUIRES" => {
    "Module::Build" => "0.28"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "Module::Build" => "0.28"
  },
  "DISTNAME" => "Bio-IRCF-CountNicks",
  "EXE_FILES" => [
    "bin/count_nicks"
  ],
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.010001",
  "NAME" => "Bio::IRCF::CountNicks",
  "PREREQ_PM" => {
    "List::MoreUtils" => 0,
    "List::Util" => 0,
    "autodie" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "File::Basename" => 0,
    "File::Slurper" => "0.009",
    "File::Spec" => 0,
    "File::Temp" => 0,
    "FindBin" => 0,
    "Test2::Bundle::Extended" => "0.000060"
  },
  "VERSION" => "0.0028",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "File::Basename" => 0,
  "File::Slurper" => "0.009",
  "File::Spec" => 0,
  "File::Temp" => 0,
  "FindBin" => 0,
  "List::MoreUtils" => 0,
  "List::Util" => 0,
  "Module::Build" => "0.28",
  "Test2::Bundle::Extended" => "0.000060",
  "autodie" => 0,
  "strict" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
