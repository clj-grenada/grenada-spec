#!/usr/bin/perl

# Quick and dirty Perl script for adjusting the metadata of the various logo
# files. Doesn't work with the original SVG, though. :-(

use 5.010;
use warnings;
use strict;
use autodie qw(:all);

use Image::ExifTool qw(:Public);

my $img = $ARGV[0];
my ($ext) = $img =~ m/([^.]+)$/;

my $et = Image::ExifTool->new();
$et->SetNewValuesFromFile('CC_Attribution_4.0_International.xmp');
#$et->SetNewValuesFromFile($img);

# Beautify PNGs exported from Inkscape
if ($ext eq "png") {
    $et->SetNewValue('PNG:Author', 'Richard Möhn');
    $et->SetNewValue('PNG:Copyright');
}

$et->WriteInfo($img) or die "Didn't work: $!";
