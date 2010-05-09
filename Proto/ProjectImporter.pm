package Proto::ProjectImporter;
use 5.010;
use strict;
use warnings;
use MongoDB;
use Readonly;
use Data::Dumper;
use Carp;
use LWP::Simple qw(get);
use Params::Validate qw(validate_pos HASHREF);
use JSON::XS qw(decode_json);

Readonly::Scalar our $DEFAULT_DB_NAME => "proto_db";
Readonly::Scalar my $GITHUB_PROJECT_URL => "http://github.com/api/v2/json/repos/show/%s/%s";

sub new { 
	validate_pos(@_, 1, { type => HASHREF }, 0);
	my ($class, $db_conn_info_ref, $db_name) = @_;
	
	my $con = MongoDB::Connection->new(%{$db_conn_info_ref});
	my $db  = $con->get_database($db_name // $DEFAULT_DB_NAME);

	bless { 
		con => $con, 
		db => $db, 
		project_coll => $db->get_collection('project') 
	}
}

sub add_project {
	my ($s, $project_name, %project_attr) = @_;
	return $s->{project_coll}->update({ name => $project_name }, {
		%project_attr,
		project_name => $project_name,
		added_time => time()
	}, { upsert => 1 });
}

sub add_git_info {
	validate_pos(@_, 1, { type => HASHREF });
	my ($s, $criteria) = @_;

	my $cursor = $s->{project_coll}->query($criteria);
	while (my $p = $cursor->next) {
		my $rep_info = $s->_fetch_github_repository($p);
		
		next unless $rep_info;
		say "Updating $p->{project_name}";

		$s->{project_coll}->update(
			{ _id => $p->{_id} },
			{ '$set' => $rep_info }
		);
	}
}

sub _fetch_github_repository {
	my ($s, $project) = @_;

	if (!$project->{owner} || !$project->{project_name}) {
		warn "invalid project ", Dumper($project);
		return;
	}

	my $url = sprintf $GITHUB_PROJECT_URL, 
		$project->{owner},
		$project->{project_name};
		
	#print $url;
	my $res = get($url);
	if (!$res) {
		warn "Unable to fetch '$url'";
		return;
	}
	
	my $rep_info = decode_json($res)->{repository};

	# convert json xs bools to real values, ugh...
	for my $k (keys %{$rep_info}) {
		next unless JSON::XS::is_bool($rep_info->{$k});
		$rep_info->{$k} = $rep_info->{$k} ? 1 : 0;
	}
	return $rep_info;
}

1;
