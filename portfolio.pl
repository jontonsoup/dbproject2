#!/usr/bin/perl -w
require "header.pl";

my $user = 'default';
my $pass = 'default';

my $login = cookie('login');

sub CashHoldings {
  eval {@col=ExecSQL($dbuser, $dbpasswd,
		     "select cash_holdings from stockuser where email='$login'",
		     "COL" )};
  if ($@) {
    print "there was an error";
  } else {
    # the query is right but the data is wrong. Probably because
    # cash_holdings is not a string
    my $cash = $col[0];
    print "<h2>Cash holdings: $col[0]</h2>";
  }
}

CashHoldings();

require "footer.pl";
