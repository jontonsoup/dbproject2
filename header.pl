#!/usr/bin/perl -w

use CGI;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use DBI;
use Time::ParseDate;

$debug=1;
@sqlinput=();
@sqloutput=();
$dbuser="jmf716";
$dbpasswd="RR62rwno";


$dbuser="gsi669";
$dbpasswd="z1OlkliU6";


#
# The session cookie will contain the user's name and password so that
# he doesn't have to type it again and again.
#
# "PSession"=>"user/password"
#
# BOTH ARE UNENCRYPTED AND THE SCRIPT IS ALLOWED TO BE RUN OVER HTTP
# THIS IS FOR ILLUSTRATION PURPOSES.  IN REALITY YOU WOULD ENCRYPT THE COOKIE
# AND CONSIDER SUPPORTING ONLY HTTPS

my $cookiename = "PSession";
my $debugcookiename = "PDebugSession";

# grab session input cookie, if any; also, debug cookie, if any
my $inputcookiecontent = cookie($cookiename);
my $inputdebugcookiecontent = cookie($debugcookiename);
my $login = cookie('login');

sub ValidUser {
	my ($user,$password)=@_;
	my @col;
	eval {@col=ExecSQL($dbuser,$dbpasswd, "select count(*) from stockuser where email='$user' and password='$password'",undef);};

	if ($@) {
		return 0;
		} else {
			return $col[0]->[0];
		}
	}


	sub MakeTable {
		my ($id,$type,$headerlistref,@list)=@_;
		my $out;
#
# Check to see if there is anything to output
#
if ((defined $headerlistref) || ($#list>=0)) {
# if there is, begin a table
#
$out="<table class=\"table table-striped\" id=\"$id\" border>";
#
# if there is a header list, then output it in bold
#
if (defined $headerlistref) {
	$out.="<tr>".join("",(map {"<td><b>$_</b></td>"} @{$headerlistref}))."</tr>";
}
#
# If it's a single row, just output it in an obvious way
#
if ($type eq "ROW") {
      #
      # map {code} @list means "apply this code to every member of the list
      # and return the modified list.  $_ is the current list member
      #
      $out.="<tr>".(map {defined($_) ? "<td>$_</td>" : "<td>(null)</td>" } @list)."</tr>";
      } elsif ($type eq "COL") {
      #
      # ditto for a single column
      #
      $out.=join("",map {defined($_) ? "<tr><td>$_</td></tr>" : "<tr><td>(null)</td></tr>"} @list);
      } else {
      #
      # For a 2D table, it's a bit more complicated...
      #
      $out.= join("",map {"<tr>$_</tr>"} (map {join("",map {defined($_) ? "<td>$_</td>" : "<td>(null)</td>"} @{$_})} @list));
  }
  $out.="</table>";
  } else {
    # if no header row or list, then just say none.
    $out.="(none)";
}
return $out;
}

#
# @list=ExecSQL($user, $password, $querystring, $type, @fill);
#
# Executes a SQL statement.  If $type is "ROW", returns first row in list
# if $type is "COL" returns first column.  Otherwise, returns
# the whole result table as a list of references to row lists.
# @fill are the fillers for positional parameters in $querystring
#
# ExecSQL executes "die" on failure.
#
sub ExecSQL {
	my ($user, $passwd, $querystring, $type, @fill) =@_;
	if ($debug) {
    # if we are recording inputs, just push the query string and fill list onto the
    # global sqlinput list
    push @sqlinput, "$querystring (".join(",",map {"'$_'"} @fill).")";
}
my $dbh = DBI->connect("DBI:Oracle:",$user,$passwd);
if (not $dbh) {
	print "failed";
    # if the connect failed, record the reason to the sqloutput list (if set)
    # and then die.
    if ($debug) {
    	push @sqloutput, "<b>ERROR: Can't connect to the database because of ".$DBI::errstr."</b>";
    }
    die "Can't connect to database because of ".$DBI::errstr;
}
my $sth = $dbh->prepare($querystring) or die $DBI::errstr;
if (not $sth) {
    #
    # If prepare failed, then record reason to sqloutput and then die
    #
    push @sqloutput, "<b>ERROR: Can't prepare '$querystring' because of ".$DBI::errstr."</b>";

    my $errstr="Can't prepare $querystring because of ".$DBI::errstr;
    $dbh->disconnect();
    die $errstr;
}
if (not $sth->execute(@fill)) {
    # if (not $sth->execute) {
    #
    # if exec failed, record to sqlout and die.

    push @sqloutput, "<b>ERROR: Can't execute '$querystring' with fill (".join(",",map {"'$_'"} @fill).") because of ".$DBI::errstr."</b>";

    my $errstr="Can't execute $querystring with fill (".join(",",map {"'$_'"} @fill).") because of ".$DBI::errstr;
    $dbh->disconnect() or die $DBI::errstr;
    die $errstr;
}
#
# The rest assumes that the data will be forthcoming.
#
#
my @data;
if (defined $type and $type eq "ROW") {
	@data=$sth->fetchrow_array();
	$sth->finish();
	if ($debug) {push @sqloutput, MakeTable("debug_sqloutput","ROW",undef,@data);}
	$dbh->disconnect();
	return @data;
}
my @ret;
while (@data=$sth->fetchrow_array()) {
	push @ret, [@data];
}
if (defined $type and $type eq "COL") {
	@data = map {$_->[0]} @ret;
	$sth->finish();
	if ($debug) {push @sqloutput, MakeTable("debug_sqloutput","COL",undef,@data);}
	$dbh->disconnect();
	return @data;
}
$sth->finish();
push @sqloutput, MakeTable("debug_sql_output","2D",undef,@ret);
$dbh->disconnect();
return @ret;
}

sub sql_jon_version{
	my ($query, $debug) =@_;
	my $db = DBI->connect( "dbi:Oracle:", $dbuser, $dbpasswd ) || die( $DBI::errstr . "\n" );

	$db->{AutoCommit}    = 0;

	$db->{RaiseError}    = 1;

	$db->{ora_check_sql} = 0;

	$db->{RowCacheSize}  = 16;

	my $SEL = $query;

	my $sth = $db->prepare($SEL);

	$sth->execute();
	my @ret;


	if ($sth->{NUM_OF_FIELDS} > 0) {
		$ret = $sth->fetchall_arrayref();
	}
	$sth->finish();
	$db->disconnect() if defined($db);
	return $ret;
}



if ($ENV{'REQUEST_METHOD'} eq "POST") {

	if(param("action") eq "login") {
		my $user = param("user");
		my $pass = param("password");
		$valid = ValidUser($user,$pass);

		if ($valid == 1){

			my $cookie=cookie(-name=>"login",
				-value=>"$user", -expires =>"+10h");
			push @outputcookies, $cookie;

			print header(-expires=>'now', -cookie=>\@outputcookies);

		}
		else {
			print "Content-type: text/html\n\n";
		}
	}
	else {
		print "Content-type: text/html\n\n";
	}
}
else {
	if(param("action") eq "logout") {

		my $cookie=cookie(-name=>"login",
			-value=>"$user", -expires =>"-10h");
		push @outputcookies, $cookie;

		print header(-expires=>'now', -cookie=>\@outputcookies);
	}
	else{
		print "Content-type: text/html\n\n";
	}
}



print "<html>";
print "<head>";
print "<script src=\"//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js\"></script>";
print "<link href=\"\/\/netdna.bootstrapcdn.com\/twitter-bootstrap\/2.1.1\/css/bootstrap-combined.min.css\" rel=\"stylesheet\">";
print "<title>Portfolio</title>";
print "</head>";

print "<body>";
my $portfolio = param("portfolio");
print "<div class=\"navbar navbar-inverse navbar-static-top\">
<div class=\"navbar-inner\">
<a class=\"brand\" href=\"manage_portfolios.pl\">Portfolioliolio</a>
<ul class=\"nav\">
<li ><a href=\"manage_portfolios.pl\">Home</a></li>";

print "<li><a href=\"history.pl\">Transaction History</a></li>
<li><a href=\"stats.pl\">Statistics</a></li>";

if(!defined($login)){
print "<li><a href=\"login.pl\">Login</a></li>
<li><a href=\"register.pl\">Register</a></li>";
}
if(defined($login)){
	print "<li><a href=\"login.pl?action=logout\">Logout</a></li>";
}
print "</ul>
</div>
</div>";

print "<div class=\"container\">";



print "<div class=\"hero-unit\">";

if(defined($login)){
}
else{
	require "login_register.pl";
	die;
}


#
# The following is necessary so that DBD::Oracle can
# find its butt
#
BEGIN {
	unless ($ENV{BEGIN_BLOCK}) {
		use Cwd;
		$ENV{PATH} = "$ENV{PATH}:/usr/lib64/qt-3.3/bin:/usr/NX/bin:/usr/local/bin:/bin:/usr/bin:/home/jmf716/bin:/home/jmf716/eecs340/proj1/minet-netclass-w12:/home/jmf716/eecs340/proj1/minet-netclass-w12/bin:/home/jmf716/www/portfolio/:/raid/oracle11g/app/oracle/product/11.2.0.1.0/db_1/bin";
		$ENV{ORACLE_BASE}="/raid/oracle11g/app/oracle/product/11.2.0.1.0";
		$ENV{ORACLE_HOME}=$ENV{ORACLE_BASE}."/db_1";
		$ENV{ORACLE_SID}="CS339";
		$ENV{LD_LIBRARY_PATH}=$ENV{ORACLE_HOME}."/lib";
		$ENV{BEGIN_BLOCK} = 1;
		$ENV{PORTF_DBMS}="oracle";
		$ENV{PORTF_DB}="cs339";
		$ENV{PORTF_DBUSER}="jmf716";
		$ENV{PORTF_DBPASS}="RR62rwno";
		exec 'env',cwd().'/'.$0,@ARGV;
	}
}
1;

