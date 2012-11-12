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
    my $cash = $col[0];
    print "<h2>Cash holdings: $col[0]</h2>";
  }
}

sub get_stocks {
   eval {@col=ExecSQL($dbuser, $dbpasswd,
         "select symbol, amount from stocks, hasstock where email = '$login'",
         "ROW" )};
  if ($@) {
    print "there was an error";
  } else {
  }

}

CashHoldings();
get_stocks();

require "footer.pl";
