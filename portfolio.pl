#!/usr/bin/perl -w
require "header.pl";
use Data::Dumper;

my $login = cookie('login');

sub CashHoldings {
  eval {@col=ExecSQL($dbuser, $dbpasswd,
		     "select cashholding from transaction where email='$login' AND rownum<=1 order by ts DESC",
		     "COL" )};
  if ($@) {
    print "there was an error<br> $DBI::errstr<br>";
  } else {
    my $cash = $col[0];
    print "<h2>Cash holdings: $col[0]</h2>";
  }
}
sub trade_request {
  print start_form(-name=>'Trade', -type=>"post"),
  h2('Trade stocks'), "<fieldset>",
  hidden(-name=>'action', default=>['trade']),
  "Stock: ", textfield(-name=>'symbol'), "<br><br>",
  "Shares: ", textfield(-name=>'amount'), "<br><br>",
  radio_group(-name=>'buy_or_sell', -values=>['buy', 'sell']), "<br><br>";
  print "<input type=\"submit\" class=\"btn btn-primary\">","</fieldset>";
}
sub get_stocks {
  $ret = sql_jon_version("select stocks.symbol, amount from stocks, hasstock where email='$login'");
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
    print "<td><a class=\"btn\" href=\"pastperformance.pl?stock=" . $ret->[0]->[0] . "\">Go</a></td>";
    print "<td><a class=\"btn\" href=\"futureperformance.pl?stock=" . $ret->[0]->[0] . "\">Go</a></td>";
    print "<td><a class=\"btn\" href=\"strategy.pl?stock=" . $ret->[0]->[0] . "\">Go</a></td>";
    print "</tr>";
  }


  print "</tbody>";
  print "</table>";

}

if($ENV{'REQUEST_METHOD'} eq "POST") {
  if (param('action') eq "trade") {
    my $stock_exists;

    my $symbol = uc param("symbol");
    my $amount = param("amount");
    my $buy_or_sell = param("buy_or_sell");
    print "symbol=$symbol<br>";
    print "amount = $amount<br>";
    print "buy_or_sell = $buy_or_sell<br>";
    print "user = $login<br>";
    
    my $ret;
    $ret = sql_jon_version("select count(*) from cs339.stockssymbols where symbol=rpad('$symbol',16)");
    # check if the stock exists
    if ($ret->[0]->[0] == 1) {
      print "$symbol is a legit stock<br>";
      $ret = sql_jon_version("select close from stocksdaily where symbol='$symbol' and rownum <=1 order by ts desc");
      my $price = $ret->[0]->[0];
      print "price = $price<br>";
      # TODO update with portfolio_num
      $ret = sql_jon_version("select cashholding from transaction where email='$login' AND rownum<=1 order by ts DESC");
      my $cash = $ret->[0]->[0];
      print "holdings: $cash<br>";

      $ret = sql_jon_version("select amount from hasstock where symbol = '$symbol' and email='$login'");
      my $amount_owned = $ret->[0]->[0] or 0;
      if (! defined $amount_owned) {
	$amount_owned = 0;
      }

      print "you have $amount_owned shares of $symbol<br>";

      if ($buy_or_sell eq "buy") {
	# checkif they gave you a number and you've got the moneys
	if ($amount =~ /[0-9]+/) {
	  if ($amount * $price <= $cash) {
	    print "you have enough money!<br>";
	    my $new_amount;
	    my $new_holdings;

	    $new_amount = $amount_owned + $amount;
	    $new_holdings = $cash - ($amount * $price);

	    $ret = sql_jon_version("insert into transaction (symbol, price, quantity, type, cashholding, email) values('$symbol', $price, $amount, 'buy', $new_holdings, '$login')");
	    if ($amount_owned == 0) {
	      sql_jon_version("insert into hasstock (email, symbol, amount) values ('$login', '$symbol', $new_amount)");
	    } else {
	      sql_jon_version("update hasstock set amount=$new_amount where email='$login' and symbol='$symbol'");
	    }

	    print "New amount: $new_amount<br>";
	    print "New balance: $new_holdings<br>";
	    
	  }
	  else {
	    print "You do not have enough money for that transaction, bru<br>";
	  }
	} else {
	  print "$amount is not a number, it's a free man!<br>";
	}
      } else {
	print "sell sell sell!";
      }
      
    } else {
      print "Invalid stock symbol";
    }
  }
  else {
    print "Post, bru";
  }
}

CashHoldings();
trade_request();
# get_stocks();

require "footer.pl";
