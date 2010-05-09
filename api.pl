#!/usr/bin/env perl
use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
use Carp;
use CGI qw(header);
use 5.010;
use JSON::XS;
use Proto::ProjectList;


print header(-type => "application/json", -charset => 'UTF-8');

print JSON::XS->new->pretty()->allow_blessed(1)->encode({ 
	projects => [ get_project_list ]
});


