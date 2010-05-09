package Proto::ProjectParser;
use 5.010;
use strict;
use warnings;

use LWP::Simple qw(get);
use Data::Dumper;
use Readonly;
use Carp;
use Exporter qw(import);
use Params::Validate qw(validate_pos CODEREF);
our @EXPORT = qw(fetch_proto_projects);

Readonly::Scalar our $DEFAULT_PROJECT_LIST_URL => 'http://github.com/masak/proto/raw/master/projects.list';

sub fetch_proto_projects {
	validate_pos(@_, 1, { type => CODEREF });
	my ($list_url, $callb) = @_;

	# Get list
	my $data = get($list_url) 
		or croak "Unable to fetch '$list_url'";

	
	parse_projects($data, $callb);
}

sub parse_projects {
	my ($data, $callb) = @_;
	my $name = undef;
	my %attr;

	for my $line (split "\n", $data) {
		chomp $line;
		next unless $line;

		if ($line =~ m/^(?:\w|-)+:$/) {
			# new project
			&{$callb}($name, %attr) 
				if defined $name;

			# reset for next
			$name = $line;
			%attr = ( );
			chop $name;
			next;
		}
			
		# Project attribute
		$line =~ m/^\s+(.*?):\s+(.*)/;
		croak "invalid line '$line'" 
			unless $1;
		$attr{$1} = $2;
	}

}

1;
