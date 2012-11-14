#!/usr/bin/perl -w


use CGI qw(:standard);
use DBI;
use Time::ParseDate;

BEGIN {
  $ENV{PORTF_DBMS}="oracle";
  $ENV{PORTF_DB}="cs339";
  $ENV{PORTF_DBUSER}="jmf716";
  $ENV{PORTF_DBPASS}="RR62rwno";

  unless ($ENV{BEGIN_BLOCK}) {
    use Cwd;
    $ENV{ORACLE_BASE}="/raid/oracle11g/app/oracle/product/11.2.0.1.0";
    $ENV{ORACLE_HOME}=$ENV{ORACLE_BASE}."/db_1";
    $ENV{ORACLE_SID}="CS339";
    $ENV{LD_LIBRARY_PATH}=$ENV{ORACLE_HOME}."/lib";
    $ENV{BEGIN_BLOCK} = 1;
    exec 'env',cwd().'/'.$0,@ARGV;
  }
};

use stock_data_access;
sub sql_jon_version{
  my ($query, $debug) =@_;
  my $db = DBI->connect( "dbi:Oracle:", "jmf716", "RR62rwno" ) || die( $DBI::errstr . "\n" );

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

my $type = param('type');
my $symbol = param('symbol');

if (!defined($type) || $type eq "text" || !($type eq "plot") ) {
  print header(-type => 'text/html', -expires => '-1h' );

  print "<html>";
  print "<head>";
  print "<title>Stock Data</title>";
  print "</head>";

  print "<body>";

  if (!defined($type) || !($type eq "text") ) {
    $type = "text";
    print "<p>You should give type=text or type=plot - I'm assuming you mean text</p>";
  }
  if (!defined($symbol)) {
    print "<p>You should give symbol=symbolname  </p>";
  }
  } elsif ($type eq "plot") {
    print header(-type => 'image/png', -expires => '-1h' );
    if (!defined($symbol)) {
    # $symbol = 'AAPL'; # default
  }
}


my @rows = ExecStockSQL("2D","select timestamp, close from ".GetStockPrefix()."StocksDaily where symbol=rpad(?,16)",$symbol);
my $ret = sql_jon_version("select ts, close from stocksdaily where symbol='$symbol'");


foreach $row (@$ret){
  push @rows, $row;
  foreach $next (@$row){
   # print "$next<br>";
 }
}
if ($type eq "text") {
  print "<pre>";
  foreach my $r (@rows) {
    print $r->[0], "\t", $r->[1], "\n";
  }
  print "</pre>";


  print "</body>";
  print "</html>";

  } elsif ($type eq "plot") {
#
# This is how to drive gnuplot to produce a plot
# The basic idea is that we are going to send it commands and data
# at stdin, and it will print the graph for us to stdout
#
#
open(GNUPLOT,"| gnuplot") or die "Cannot run gnuplot";

  print GNUPLOT "set term png\n";           # we want it to produce a PNG
  print GNUPLOT "set output\n";             # output the PNG to stdout
  print GNUPLOT "plot '-' using 1:2 with linespoints\n"; # feed it data to plot
  foreach my $r (@rows) {
    print GNUPLOT $r->[0], "\t", $r->[1], "\n";
  }
  print GNUPLOT "e\n"; # end of data

  #
  # Here gnuplot will print the image content
  #

  close(GNUPLOT);
}




