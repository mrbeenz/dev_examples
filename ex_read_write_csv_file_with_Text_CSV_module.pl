#!/usr/bin/perl
# Example CSV file processing in Perl

use Text::CSV_XS;   # C version of Text::CSV - much faster
use strict;         # Enforce variable declaration
use feature 'say';  # Enable use of say for printing
use warnings;
use File::Basename; 

say "Script ".basename($0)." executing";

my $arg_count = @ARGV;
if ($arg_count < 2) {  
  say "Usage is: t5.pl input-file-name output-file-name input-csv-delimiter output-csv-delimiter";
  exit 2;
}

my $in_file = shift; # Input file name argument
my $out_file = shift; # Output file name argument
my $in_delim = shift || ','; # Input CSV file delimiter with default
my $out_delim = shift || ','; # Output CSV file delimiter with default

if ( ! -e $in_file) {
  # Error
  say "Specified input filename does not exist";
  exit(2);
}

# Check if output file exists
if ( -e $out_file ) {
  say "Warning - output file already exists and will be deleted";
  unlink($out_file);
}
say "Input file          : < $in_file >";
say "Input CSV delimiter : < $in_delim >";
say "Output file         : < $out_file >";
say "Output CSV delimiter: < $out_delim >";

# Initialize CSV parsing module

my $csv = Text::CSV_XS->new({
             sep_char => $in_delim, # CSV delimiter character
             allow_whitespace => 1, # Strip any whitespace around delimiter
             strict => 1,           # Raise error if insufficient fields found
             eol => "\n"            # Specify end of line character
          });

# Open files
open(INFILE, "< $in_file") or die "Error opening file '$in_file' [$1!]";
my $OUTFILE;
open($OUTFILE, "> $out_file") or die "Error opening output file '$out_file' [$!]";

my @recs; # Array to hold all recordsi for outputting

while (my $line = <INFILE>) {
    chomp($line);
    say $line;
    if ($csv->parse($line)) {
       my @in_fields = $csv->fields();i # Store all parsed fields into an array
       push @recs, \@in_fields;        # Push array reference into array
    }
    else {
     warn "Line could not be parsed"; # Output message and line no information
     say "<$line>"; # Echo line
   }    
}
# Output CSV file with required delimiter
$csv->sep($out_delim); # Change CSV delimiter
$csv->print($OUTFILE, $_) for @recs; # Print all records

# Close files
close(INFILE) or die "Error closing input file '$in_file' [$!]";
close($OUTFILE) or  die "Error closing output file '$out_file' [$!]"; 
 
exit 0;
