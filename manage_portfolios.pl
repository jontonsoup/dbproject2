#!/usr/bin/perl -w
require "header.pl";
use Data::Dumper;

my $login = cookie('login');
  
print "<h2>Your Portfolios</h2>";

# display table of portfolios
$ret = sql_jon_version("select id,email from portfolio where email='$login'");
#print Dumper(@ret);
print "<table class=\"table table-striped\">";
print "<thead>";
print "<tr><td>ID</td><td>User</td>></tr>";
print "<tbody>";
foreach $row (@$ret){
  print "<tr>";
  my $ind = 0;
  foreach $next (@$row){
    # if it's the ID, insert link
    if ($ind == 0) {
     print "<td><a href=\"portfolio.pl?portfolio_id=$next\" class=\"btn\">$next</a></td>";
    } else {
     print "<td>$next<td>";
    }
    $ind = $ind + 1;
  }
  print "</tr>";
}


print "</tbody>";
print "</table>";






# detect post requests
# if post, create a portfolio
# otherwise, make form
if ($ENV{'REQUEST_METHOD'} eq "POST") {
  if (param('cash') eq undef) {
    print "<h3>You didn't provide an initial cash value!</h3>";
  } else {
  # get sys_guid() from db and store it in a local variable
  eval {@row=ExecSQL($dbuser, $dbpasswd, "select sys_guid() from dual", undef)};
  if ($@) { print "error";} else {  }
  #print @row->[0]->[0];
  my $portfolio_id = @row->[0]->[0];
   

  # create portfolio
  #my $portfolio_id = param('portfolio_id');
  my $cash = param('cash');

  eval {@row=ExecSQL($dbuser, $dbpasswd, "insert into portfolio (id, email) values ('$portfolio_id', '$login')", undef)};
  if ($@) {
    print "error occurred<br> $DBI::errstr<br>";
  } else {
    #print "no error occurred<br>";
  }


  # add the initial transaction
  eval {@row=ExecSQL($dbuser, $dbpasswd, "insert into transaction (symbol, price, quantity, type, cashholding, email, portfolio_id)
                                          values (?, ?, ?, ?, ?, ?, ? )", undef, "cash", "0", "0", "cash", $cash, $login, $portfolio_id);}; 
  if ($@) {
    print "error occurred<br>";
  } else {
    #print "no error occurred<br>";
    print "<h3>now, reload</h3>";
  }
  }
  
}
else {
  print start_form(-name=>'CreatePortfolio', -type=>'post'),
  h2('New Portfolio'), "<fieldset>",
  hidden(-name=>'action',default=>['login']),
  "Cash: ", textfield(-name=>'cash'), "<br><br>";
  print "<input type=\"submit\" class=\"btn btn-primary\">", "</fieldset>";
}


require "footer.pl";
