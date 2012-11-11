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
  print "connecting with $user, $passwd<br>";
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
  print "prepare: $querystring";
  my $sth = $dbh->prepare($querystring) or die $DBI::errstr;
  if (not $sth) {
    #
    # If prepare failed, then record reason to sqloutput and then die
    #
    print "failed";
    push @sqloutput, "<b>ERROR: Can't prepare '$querystring' because of ".$DBI::errstr."</b>";

    my $errstr="Can't prepare $querystring because of ".$DBI::errstr;
    $dbh->disconnect();
    die $errstr;
  }
  print "fill: @fill";
  if (not $sth->execute(@fill)) {
    # if (not $sth->execute) {
    print "failed";
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



print "Content-type: text/html\n\n";

print "<html>";
print "<head>";
print "<script src=\"\/\/ajax.googleapis.com\/ajax\/libs\/jquery\/1.8.2\/jquery.min.js\/\"></script>";
print "<link href=\"\/\/netdna.bootstrapcdn.com\/twitter-bootstrap\/2.1.1\/css/bootstrap-combined.min.css\" rel=\"stylesheet\">";
print "<title>Portfolio</title>";
print "</head>";

print "<body>";

print "<div class=\"navbar navbar-inverse navbar-static-top\">
<div class=\"navbar-inner\">
<a class=\"brand\" href=\"#\">Portfolioliolio</a>
<ul class=\"nav\">
<li ><a href=\"\">Home</a></li>
<li><a href=\"login.pl\">Login</a></li>
<li><a href=\"register.pl\">Register</a></li>
</ul>
</div>
</div>";

print "<div class=\"container\">";



print "<div class=\"hero-unit\">";

#
# The following is necessary so that DBD::Oracle can
# find its butt
#
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
