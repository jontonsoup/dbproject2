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
  foreach $next (@$row){
     print "<td>$next</td>";
  }
  print "</tr>";
}


print "</tbody>";
print "</table>";






# detect post requests
# if post, create a portfolio
# otherwise, make form
if ($ENV{'REQUEST_METHOD'} eq "POST") {
  # create portfolio
  my $portfolio_id = param('portfolio_id');
  eval {@row=ExecSQL($dbuser, $dbpasswd, "insert into portfolio values ($portfolio_id, '$login')", undef)};
  if ($@) {
    print "bad";
  } else {
    print "good";
  }

}
else {
  print start_form(-name=>'CreatePortfolio', -type=>'post'),
  h2('New Portfolio'), "<fieldset>",
  hidden(-name=>'action',default=>['login']),
  "ID: ", textfield(-name=>'portfolio_id'),"<br><br>";
  print "<input type=\"submit\" class=\"btn btn-primary\">", "</fieldset>";
}


require "footer.pl";
