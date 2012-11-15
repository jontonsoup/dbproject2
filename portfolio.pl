#!/usr/bin/perl -w
require "header.pl";
use Data::Dumper;
my $user = 'default';
my $pass = 'default';

my $login = cookie('login');

# if no portfolio_id parameter provided, just up and die!
if (param('portfolio_id') eq undef) {die;}

my $portfolio_id = param('portfolio_id');

print "<br>Portfolio ID: $portfolio_id<br>";

sub CashHoldings {
  eval {@col=ExecSQL($dbuser, $dbpasswd,
   "select cashholding from transaction where email='$login' and portfolio_id='$portfolio_id' AND rownum<=1 order by ts DESC",
   "COL" )};
  if ($@) {
    print "there was an error<br> $DBI::errstr<br>";
    } else {
      my $cash = $col[0];
      print "<h2>Cash holdings: $col[0]</h2>";
    }
  }
  sub get_stocks {
   # eval {@col1=ExecSQL($dbuser, $dbpasswd,
   #       "select stocks.symbol, amount from stocks, hasstock where email='$login'",
   #       "COL" )};


$ret = sql_jon_version("select symbol, amount from stocks natural join hasstock where portfolio_id='$portfolio_id'");
print Dumper(@ret);
print "<table class=\"table table-striped\">";
print "<thead>";
print "<tr><td>Stock</td><td># Shares</td><td>Past Performance</td><td>Future Performance</td><td>Strategy</td></tr>";
print "<tbody>";
foreach $row (@$ret){
  print "<tr>";
  foreach $next (@$row){
   print "<td>$next</td>";
 }
 print "<td><a class=\"btn\" href=\"pastperformance.pl?stock=" . $row->[0] . "\">Go</a></td>";
 print "<td><a class=\"btn\" href=\"futureperformance.pl?stock=" . $row->[0] . "\">Go</a></td>";
 print "<td><a class=\"btn\" href=\"strategy.pl?stock=" . $row->[0] . "\">Go</a></td>";
 print "</tr>";
}


print "</tbody>";
print "</table>";

}

CashHoldings();
get_stocks();

require "footer.pl";
