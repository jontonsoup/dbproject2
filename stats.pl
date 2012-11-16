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
<h3>COV, Beta, and Covariance Matrix</h3>
";

require "footer.pl";

