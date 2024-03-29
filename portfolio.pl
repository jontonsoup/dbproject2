#!/usr/bin/perl -w
require "header.pl";
use Data::Dumper;

my $login = cookie('login');

# if no portfolio_id parameter provided, just up and die!
if (param('portfolio_id') eq undef) {die;}

my $portfolio_id = param('portfolio_id');

my $is_portfolio_related_page = 1;


print "<h3>Portfolio ID: $portfolio_id</h3>";

print "<a class=\"btn btn-primary\" href=\"stats.pl?portfolio_id=$portfolio_id\">Statistics About This Portfolio</a>";

print "<hr>";


sub CashHoldings {
  $ret = sql_jon_version("select cashholding from (select * from transaction where email='$login' and portfolio_id='$portfolio_id' order by ts DESC) where rownum<=1");
  my $cash = $ret->[0]->[0];
  print "<h2>Cash holdings: $cash</h2>";
  $ret = sql_jon_version("select sum(close*amount) from most_recent_stockinfo natural join hasstock where portfolio_id = '$portfolio_id'");
  my $total = $ret->[0]->[0];
  print "<h2>Total Portfolio Value: $total</h2>";
}


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

sub add_money {
  print start_form(-name=>'addmoney', -type=>"post"),
  h2('Withdraw \ Deposit Cash'), "<fieldset>",
  hidden(-name=>'action', default=>['cash']),
  hidden(-name=>'portfolio_id', default=>[$portfolio_id]),
  "Amount : ", textfield(-name=>'amount'), "<br><br>",
  radio_group(-name=>'add_or_subtract', -values=>['Withdraw', 'Deposit']), "<br><br>";
  print "<input type=\"submit\" class=\"btn btn-primary\">","</fieldset>";
  print "</form>";
  if($ENV{'REQUEST_METHOD'} eq "POST") {
    if (param('action') eq "cash") {
      my $amount = param("amount");
      my $add_or_subtract = param("add_or_subtract");
      $ret = sql_jon_version("select cashholding from (select * from transaction where email='$login' and portfolio_id='$portfolio_id' order by ts DESC) where rownum<=1");
      my $cash = $ret->[0]->[0];
      if ($add_or_subtract eq "Withdraw"){
        $new_holdings = $cash - $amount;
        if($amount > $cash){
          print "<h3>You don't have enough money for that!</h3>";
        }
        else {
	  print "<h3>Done!</h3>";
          $ret = sql_jon_version("insert into transaction (symbol, price, quantity, type, cashholding, email, portfolio_id) values('cash', 0, $amount, 'Withdraw', $new_holdings, '$login', '$portfolio_id')");
        }
      }
      elsif($add_or_subtract eq "Deposit"){
        $new_holdings = $cash + $amount;
        $ret = sql_jon_version("insert into transaction (symbol, price, quantity, type, cashholding, email, portfolio_id) values('cash', 0, $amount, 'Deposit', $new_holdings, '$login', '$portfolio_id')");
	print "<h3>Done!</h3>";
      }
    }
  }

}

sub trade_request {
  print"<br><hr>";
  print start_form(-name=>'Trade', -type=>"post"),
  h2('Trade stocks'), "<fieldset>",
  hidden(-name=>'action', default=>['trade']),
  hidden(-name=>'portfolio_id', default=>[$portfolio_id]),
  "Stock: ", textfield(-name=>'symbol'), "<br><br>",
  "Shares: ", textfield(-name=>'amount'), "<br><br>",
  radio_group(-name=>'buy_or_sell', -values=>['Buy ', 'Sell ']), "<br><br>";
  print "<input type=\"submit\" class=\"btn btn-primary\">","</fieldset>";
  print "</form>";
  $ret = sql_jon_version("select symbol, close from most_recent_stockinfo where close is not null order by symbol");
  print"<br><hr>";
  print "<h3>Available Stocks to Buy</h3>";
  print "<div style=\"height:150px; overflow:scroll;\">";
  print "<table class=\"table table-striped\">";
  print "<thead>";
  print "<tr><td>Stock</td><td>Current Price</td></tr>";
  print "<tbody>";
  foreach $row (@$ret){
    print "<tr>";
    print "<td>", $row->[0], "</td>";
    print "<td>", $row->[1], "</td>";
    print "</tr>";
  }
  print "</tbody></table>";
  print "</div>";
  print "<hr>";
}

if($ENV{'REQUEST_METHOD'} eq "POST") {
  if (param('action') eq "trade") {
    my $stock_exists;

    my $symbol = uc param("symbol");
    my $amount = param("amount");
    my $buy_or_sell = param("buy_or_sell");
    # print "symbol=$symbol<br>";
    # print "amount = $amount<br>";
    # print "buy_or_sell = $buy_or_sell<br>";
    # print "user = $login<br>";

    my $ret;
    $ret = sql_jon_version("select count(*) from cs339.stockssymbols where symbol=rpad('$symbol',16)");
    # check if the stock exists
    if ($ret->[0]->[0] == 1) {
      # print "$symbol is a legit stock<br>";
      $ret = sql_jon_version("select close from (select * from stocksdaily where symbol='$symbol' order by ts desc) where rownum <=1");
      my $price = $ret->[0]->[0];
      # print "Price = $price<br>";
      $ret = sql_jon_version("select cashholding from (select * from transaction where email='$login' and portfolio_id='$portfolio_id' order by ts DESC) where rownum<=1");
      my $cash = $ret->[0]->[0];
      # print "Holdings: $cash<br>";

      $ret = sql_jon_version("select amount from hasstock where symbol = '$symbol' and portfolio_id='$portfolio_id'");
      my $amount_owned = $ret->[0]->[0] or 0;
      if (! defined $amount_owned) {
	$amount_owned = 0;
      }

      # print "You have $amount_owned shares of $symbol<br>";

      if ($buy_or_sell eq "Buy ") {
	# checkif they gave you a number and you've got the moneys
	if ($amount =~ /[0-9]+/) {
	  if ($amount * $price <= $cash) {
	    # print "You have enough money!<br>";
	    my $new_amount;
	    my $new_holdings;

	    $new_amount = $amount_owned + $amount;
	    $new_holdings = $cash - ($amount * $price);

	    $ret = sql_jon_version("insert into transaction (symbol, price, quantity, type, cashholding, email, portfolio_id) values('$symbol', $price, $amount, 'buy', $new_holdings, '$login', '$portfolio_id')");
	    if ($amount_owned == 0) {
	      sql_jon_version("insert into hasstock (portfolio_id, symbol, amount) values ('$portfolio_id', '$symbol', $new_amount)");
	    } else {
	      sql_jon_version("update hasstock set amount=$new_amount where portfolio_id='$portfolio_id' and symbol='$symbol'");
	    }

	    # print "New amount: $new_amount<br>";
	    # print "New balance: $new_holdings<br>";
      print "<div class=\"alert alert-success\">Success!</div>";

	  }
	  else {

	    print "<div class=\"alert alert-error\">You do not have enough money for that transaction, bru</div>";
	  }
	} else {
	  print "<div class=\"alert alert-error\">$amount is not a number, man!</div>";
	}
      } else {
	my $new_amount;
	$new_amount = $amount_owned - $amount;
	if ($new_amount >= 0) {

	  print "<div class=\"alert alert-success\">You have $new_amount shares of $symbol left</div>";
	  my $new_holdings = $cash + ($price * $amount);
	  # add the transaction
	  sql_jon_version("insert into transaction (symbol, price, quantity, type, cashholding, email, portfolio_id) values('$symbol', $price, $amount, 'sell', $new_holdings, '$login', '$portfolio_id')");
	  # if >0 left, update hasstock
	  if ($new_amount > 0) {
	    sql_jon_version("update hasstock set amount=$new_amount where portfolio_id='$portfolio_id' and symbol='$symbol'");
	  } else {
	    # else delete from hasstock
	    sql_jon_version("delete from hasstock where portfolio_id='$portfolio_id' and symbol='$symbol'");
	  }
	} else {
	  print "You don't have that many shares to sell<br>";
	}
      }

    } else {
      print "Invalid stock symbol";
    }
  }
  else {
  }
}

CashHoldings();
print "<hr>";
get_stocks();
print "<hr>";
trade_request();
add_money();

require "footer.pl";
