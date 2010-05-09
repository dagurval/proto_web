use 5.010;
use strict;
use warnings;

use Data::Dumper;

use Proto::ProjectParser qw(fetch_proto_projects);
use Proto::ProjectImporter;

my $importer = Proto::ProjectImporter->new({ });

fetch_proto_projects($Proto::ProjectParser::DEFAULT_PROJECT_LIST_URL, sub {
	my ($name, %attr) = @_;
	say "Importing '$name'";
	$importer->add_project($name, %attr);
});

say "Fetching github data";
$importer->add_git_info({ type => { '$ne' => 'pseudo' }});

say "Done!";
