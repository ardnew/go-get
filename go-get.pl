#!/usr/bin/perl

use strict;
use warnings;

use File::Basename;
use File::Spec::Functions;
use File::Path qw| make_path |;

my $name = basename($0);

die <<__usage__
usage:
  $name <package> [cmdpath]

description:
  $name downloads the given Go package source code to GOPATH. The package path
  may be specified as either a fully-qualified URL or local Go import path.

  If the given package path is not a fully-qualified URL, it attempts to
  determine the URL based on a table of known hosts, mapping the host name in
  the first component of the given Go import path to its corresponding URL.

  The user may also specify a relative file path cmdpath (from the root of the
  package import path), referring to an executable to build and install after
  the repository has been downloaded.

  Currently, the only package resources supported are Git repositories.

__usage__
  unless @ARGV > 0;

# / -------------------------------------------------------------------------- \
# | If the user does not provide a fully-qualified URL, we can automatically   |
# | construct one based on the given package import path. The first component  |
# | of the given path must match one of the keys in the following table.       |
# | With GOPATH convention, this first component is usually a host name.       |
# | Feel free to add any other default hosts you might use.                    |

my %hosts = (
  "github.com" => "https://github.com",
);

# \ -------------------------------------------------------------------------- /

my ($url, $cmd) = @ARGV;

# Check if a fully-qualified URL was provided and use it directly
my ($pkg) = ($url =~ m|^\w+://(.+?)(\.git)?$|g);

# Otherwise, try to identify the host from the given import path in our
# table of known hosts, and use its corresponding fully-qualified URL.
unless (defined $pkg) {

  # For each host => url mapping in the %hosts table:
  while (my ($host, $remote) = each %hosts) {

    # Escape any regexp-meaningful characters in the hostname
    $host = quotemeta $host;

    # Check if the given import path starts with the current host name
    # from our known hosts table
    if (my ($h, $p) = ($url =~ m|^($host)/(.+)$|g)) {

      # Construct the fully-qualified URL and local package import path
      $url = "$remote/$p.git";
      $pkg = "$h/$p";
    }
  }
}

if (defined $url and defined $pkg) {

  # Use catdir to convert the directory separator for the current system
  $pkg = catdir(split /\//, "$ENV{GOPATH}/src/$pkg");

  # Ensure we are grabbing from a git repository URL
  $url .= ".git" unless $url =~ /\.git$/;

  # Create the local directory if it does not exist
  make_path($pkg) unless -d $pkg;

  # If the local source directory already exists and contains .git metadata,
  # update the source via "git pull". Otherwise, "git clone" the repo.
  my ($sys);
  if (not -d catdir($pkg, ".git")) {
    $sys .= sprintf "git clone -v \"%s\" \"%s\"; ", $url, $pkg;
  } else {
    $sys .= sprintf "cd \"%s\"; git pull -v; ", $pkg;
  }

  # If a relative path argument was provided, try to build and install it
  # using "go install"
  $sys .= sprintf "cd \"%s\"; ", $pkg;
  if (defined $cmd) {

    # Convert the path separators for the current system
    $cmd = catfile(".", catdir(split /\//, $cmd));

    # Call "go install" to build and install the given cmd if it exists
    if (-d catdir($pkg, $cmd)) {
      $sys .= sprintf "go install -v \"%s\"; ", $cmd;
    } else {
      printf STDERR "warning: go command not found in repo: %s\n", $cmd;
    }
  }

  # Execute all shell commands in a single system call invocation.
  exit system $sys;
}
