#!/usr/bin/perl -w
require "header.pl";
use Data::Dumper;
my $user = 'default';
my $pass = 'default';

my $login = cookie('login');

# This page allows users to see the past history of bought/sold stocks

print "
<h2>History</h1>
<h3>Record of Bought/Sold Stocks</h3>
";

# collects and tabulates history of transactions for current user
sub HistoryTable {
  @ret = sql_jon_version("select ts, symbol, price, quantity, type, cashholding from transaction where email='$login' AND rownum<=10 order by ts DESC");
  #print Dumper(@ret);
  print "<table class=\"table table-striped\">";
  print "<thead>";
  print "<tr><td>Timestamp</td><td>Symbol</td><td>Price</td><td>Quantity</td><td>Type</td><td>Cash Holding</td></tr>";
  print "<tbody>";
  foreach $row (@$ret){
    print "<tr>";
    foreach $next (@$row){
       print "<td>$next</td>";
    }
    #print "<td><a class=\"btn\" href=\"pastperformance.pl?stock=" . $ret->[0]->[0] . "\">Go</a></td>";
    #print "<td><a class=\"btn\" href=\"futureperformance.pl?stock=" . $ret->[0]->[0] . "\">Go</a></td>";
    #print "<td><a class=\"btn\" href=\"strategy.pl?stock=" . $ret->[0]->[0] . "\">Go</a></td>";
    print "</tr>";
  }


  print "</tbody>";
  print "</table>";

}

HistoryTable();

require "footer.pl";

