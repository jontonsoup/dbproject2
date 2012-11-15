#!/usr/bin/perl -w

use Data::Dumper;
use Finance::Quote;
use CGI;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use DBI;
use Time::ParseDate;

BEGIN {
	unless ($ENV{BEGIN_BLOCK}) {
		use Cwd;
		$ENV{ORACLE_BASE}="/raid/oracle11g/app/oracle/product/11.2.0.1.0";
		$ENV{ORACLE_HOME}=$ENV{ORACLE_BASE}."/db_1";
		$ENV{ORACLE_SID}="CS339";
		$ENV{LD_LIBRARY_PATH}=$ENV{ORACLE_HOME}."/lib";
		$ENV{BEGIN_BLOCK} = 1;
		exec 'env',cwd().'/'.$0,@ARGV;
	}
}

$dbuser="jmf716";
$dbpasswd="RR62rwno";

sub rtrim{
  my $string = $_;
  $string =~ s/\s*$//;
  return $string;
}

sub getstock{
	@info=("date","time","high","low","close","open","volume");


	@symbols=map(rtrim, @_);

	$con=Finance::Quote->new();

	$con->timeout(60);

	%quotes = $con->fetch("usa",@symbols);

	$date = '';
	$time = '';
	$high = '';
	$low = '';
	$close = '';
	$open = '';
	$volume = '';

	foreach $symbol (@symbols) {
		print Dumper($symbol);
		print $symbol,"\n=========\n";
		if (!defined($quotes{$symbol,"success"})) {
			print "No Data\n";
			} else {
				print Dumper(@info);
				$date = $quotes{$symbol,"date"};
				$time = $quotes{$symbol,"time"};
				$high = $quotes{$symbol,"high"};
				$low = $quotes{$symbol,"low"};
				$close = $quotes{$symbol,"close"};
				$open = $quotes{$symbol,"open"};
				$volume = $quotes{$symbol,"volume"};
				my $time1 = parsedate("$date $time");
				print "unix: ",$time1, "\n";

				foreach $key (@info) {
					if (defined($quotes{$symbol,$key})) {
						print $key,"\t",$quotes{$symbol,$key},"\n";
					}
				}
				sql_jon_version("insert into stocks values ('$symbol',0,0,0)");
				sql_jon_version("insert into stocksdaily (symbol,ts,high,low,close,open,volume) values ('$symbol', '$time1','$high','$low','$close','$open','$volume')");

			}
			print "\n";
		}
	}

	sub sql_jon_version {
		my ($query) = @_;
		my $db = DBI->connect( "dbi:Oracle:", $dbuser, $dbpasswd ) || die( $DBI::errstr . "\n" );

		$db->{AutoCommit} = 0;

		$db->{RaiseError} = 1;

		$db->{ora_check_sql} = 0;

		$db->{RowCacheSize} = 16;

		my $SEL = $query;

		my $sth = $db->prepare($SEL);

		if (not $sth->execute()) {
			return;
		}

		my @ret;
		if ($sth->{NUM_OF_FIELDS} > 0) {
			$ret = $sth->fetchall_arrayref();
		}
		$sth->finish();
		$db->disconnect() if defined($db);
		return $ret;
	}

	#none of the stocks in cs339.stocksymbols are in the online repo
	$ret = sql_jon_version("select distinct symbol from cs339.stocksdaily");
	foreach $row (@$ret){
		foreach $next (@$row){
			getstock($next);
		}
	}

	$ret = sql_jon_version("select symbol from stocks");
	foreach $row (@$ret){
		foreach $next (@$row){
			getstock($next);
		}
	}





