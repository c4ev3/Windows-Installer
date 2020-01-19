use strict;
use warnings;

use File::Temp qw/tempfile/;
use Cwd qw/getcwd/;

my (%defs, @args, $script);

for my $i (0..$#ARGV) {
    local $_ = $ARGV[$i];

    if (m{^/}) {
        if (m{^/D([^=]+)=(.*)}) {
            $defs{$1} = $2;
        } else {
            push @args, $_;
        }

        undef $ARGV[$i];
    }
}

@ARGV = grep { defined } @ARGV;

my ($fh, $filename) = tempfile("isstmp_XXXXXXXXXX", DIR => getcwd);

while (<>) {
    my $line = $_;
    while (my ($key, $val) = each %defs) {
        if ($line =~ /^\s*;?\s*#\s*define\s+$key\s/) {
            $line = qq(#define $key	"$val"\n);
        }
    }

    print $fh $line;
}

print join(' ', 'iscc', @args, $filename), "\n";
exec 'iscc', @args, $filename;
