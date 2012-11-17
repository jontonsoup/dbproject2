#!/usr/bin/perl -w
require "header.pl";
use Data::Dumper;

my $login = cookie('login');

# die if portfolio_id not supplied
if ((param('portfolio_id') eq undef)) {
  print "<h2>You didn't supply a portfolio_id!</h3>";
  die;
}

my $portfolio_id = param('portfolio_id');

# This page displays statistics about a given portfolio

print "
<h2>Statistics about Portfolio</h1>

<h3>Coefficient of Variance and Beta of Stocks</h3>
";


# get current stocks for this portfolio (look up query in portfolio.pl)
# get from and to times from the user with a form
# calculate coeff of covar and beta of each stock and display in a table

sub get_stocks {
  $ret = sql_jon_version("select symbol, amount from stocks natural join hasstock where portfolio_id='$portfolio_id'");

  print "<h2>Current Portfolio</h2>";
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

get_stocks();

# get_info.pl can be used to get stddev, avg, mean, min, and max of a stock over from and to timestamp
# we also need current stocks info so...custom get_info.pl?
# coeff of var for a stock = stdev/mean


require "footer.pl";

