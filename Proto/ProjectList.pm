package Proto::ProjectList;
use 5.010;
use strict;
use warnings;
use Exporter qw(import);
use MongoDB;
our @EXPORT = qw(get_project_list);

sub get_project_list {
	my $db = MongoDB::Connection->new->get_database('proto_db');
	my $coll = $db->get_collection('project');

	my $cursor = $coll->find({ type => { '$ne' => 'pseudo' }});
	my @projects;
	
	while (my $p = $cursor->next) {
		push @projects, $p
	};

	return @projects;

}

1;
