use strict;
use warnings;

use 5.008001;

use ExtUtils::MakeMaker 6.17;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Dancer2::Plugin::Queue backend using IronMQ",
  "AUTHOR" => "Mikko Koivunalho <mikkoi\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.17"
  },
  "DISTNAME" => "Dancer2-Plugin-Queue-IronMQ",
  "LICENSE" => "apache",
  "MIN_PERL_VERSION" => "5.008001",
  "NAME" => "Dancer2::Plugin::Queue::IronMQ",
  "PREREQ_PM" => {
    "Const::Fast" => 0,
    "Dancer2::Plugin::Queue" => "0.006",
    "Dancer2::Plugin::Queue::Role::Queue" => 0,
    "IO::Iron::IronMQ::Client" => "0.12",
    "IO::Iron::IronMQ::Message" => "0.12",
    "IO::Iron::IronMQ::Queue" => "0.12",
    "Moose" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::Spec" => 0,
    "HTTP::Tiny" => 0,
    "Test::More" => 0,
    "Test::Roo" => 0,
    "Test::TCP" => 0
  },
  "VERSION" => "0.003",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Const::Fast" => 0,
  "Dancer2::Plugin::Queue" => "0.006",
  "Dancer2::Plugin::Queue::Role::Queue" => 0,
  "ExtUtils::MakeMaker" => 0,
  "File::Spec" => 0,
  "HTTP::Tiny" => 0,
  "IO::Iron::IronMQ::Client" => "0.12",
  "IO::Iron::IronMQ::Message" => "0.12",
  "IO::Iron::IronMQ::Queue" => "0.12",
  "Moose" => 0,
  "Test::More" => 0,
  "Test::Roo" => 0,
  "Test::TCP" => 0,
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
