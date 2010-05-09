#!/usr/bin/env perl
use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);
use Template;
use Readonly;
use Data::Dumper;
use Carp;
use CGI qw(header);
use 5.010;

my $tpl = Template->new(
	INCLUDE_PATH => "tpl", 
	DEBUG => 1,
	ANYCASE => 0,
	OUTPUT_PATH => "tt_tmp",
	COMPILE_EXT => "ctpl",
	COMPILE_DIR => "tt_tmp"
);

print header(-type => "text/html", -charset => 'UTF-8');

$tpl->process('index.tpl', { })
	or croak "Tpl error: ", $tpl->error, "\n";

