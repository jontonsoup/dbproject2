#!/usr/bin/perl -w
require "header.pl";


if ($ENV{'REQUEST_METHOD'} eq "POST") {
		print "<h2>Thanks for logging in!</h2>";
    #print "<a href=\"portfolio.pl\" class= \"btn\">Go Home!</a>";
    print "<a href=\"manage_portfolios.pl\" class=\"btn\">Manage Portfolios</a>";

    #my $login = cookie('login');
    # my $portfolio_id = 0;

    # create a portfolio
    #eval {@row=ExecSQL($dbuser, $dbpasswd, "insert into portfolio values ($portfolio_id, '$login')", undef)};
    #if ($@) {
    #  print "there was an error creating a portfolio<br> $DBI::errstr<br>";
    #} else {
    #  print "<h3>created a portfolio for you!</h3>";
    #}

}

else {

		print start_form(-name=>'Login', -type=>"post"),
		h2('Login!'), "<fieldset>",
		hidden(-name=>'action',default=>['login']),
		"Name: ",textfield(-name=>'user'),"<br><br>",
		"Password: ",password_field(-name=>'password'), "<br><br>";
		print "<input type=\"submit\" class=\"btn btn-primary\">","</fieldset>";
}

require "footer.pl";
