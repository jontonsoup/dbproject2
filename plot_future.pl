#!/usr/bin/perl -w


use CGI qw(:standard);
use DBI;
use Time::ParseDate;
use Data::Dumper;

BEGIN {
  $ENV{PORTF_DBMS}="oracle";
  $ENV{PORTF_DB}="cs339";
  $ENV{PORTF_DBUSER}="jmf716";
  $ENV{PORTF_DBPASS}="RR62rwno";
  $ENV{PATH} = "$ENV{PATH}:/usr/lib64/qt-3.3/bin:/usr/NX/bin:/usr/local/bin:/bin:/usr/bin:/home/jmf716/bin:/home/jmf716/eecs340/proj1/minet-netclass-w12:/home/jmf716/eecs340/proj1/minet-netclass-w12/bin:/home/jmf716/www/portfolio/:/raid/oracle11g/app/oracle/product/11.2.0.1.0/db_1/bin";
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
  print "<link href=\"\/\/netdna.bootstrapcdn.com\/twitter-bootstrap\/2.1.1\/css/bootstrap-combined.min.css\" rel=\"stylesheet\">";
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
my $time = param("time");
my $steps = $time + ($time * 5);

my @rows= `time_series_symbol_project.pl $symbol $time AWAIT $steps ARIMA 2 1 2 | tail -$steps 2>&1`;
 #  foreach $row (@rows){
 #    @row = split(' ', $row);
 # }

 @rows = map(split(' ', $_), @rows);
 if ($type eq "text") {
  print "<table class=\"table table-striped\">";
  print "<thead>";
  print "<tr><td>Time</td><td>Past Value</td><td>Predicted Value</td></tr>";
  print "<tbody>";

  for ($count = 0; $count < scalar (@rows); $count = $count + 3) {
   print "<tr>";
   print "<td>",@rows[$count], "</td>";
   print "<td>",@rows[$count + 1], "</td>";
   print "<td>",@rows[$count + 2], "</td>";
   print "</tr>";
 }
 print "</table>";

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
  for ($count = 0; $count < scalar (@rows); $count = $count + 3) {
    if (.00001 > @rows[$count + 1]){
      print GNUPLOT @rows[$count], "\t", @rows[$count + 2],"\n";
    }
    else{
      print GNUPLOT @rows[$count], "\t", @rows[$count + 1],"\n";
    }
  }
  # print GNUPLOT "10", "\t", "100","\n";
  # print GNUPLOT "11", "\t", "100","\n";
  print GNUPLOT "e\n"; # end of data

  #
  # Here gnuplot will print the image content
  #

  close(GNUPLOT);
}




