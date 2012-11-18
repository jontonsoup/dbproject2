if ($ENV{'REQUEST_METHOD'} eq "POST") {
	if (param('action') eq "login")
	{
		print "<h2>Thanks for logging in!</h2>";
    print "<a href=\"manage_portfolios.pl\" class=\"btn\">Manage Portfolios</a>";
	}
	else {
    my $user = param("user");
    my $pass = param("password");
    #my $cash = param("cash");
    my @rows;
    eval { ExecSQL($dbuser,$dbpasswd,"insert into stockuser (email, password) values (?, ?)", undef, $user, $pass);};
    #eval { ExecSQL($dbuser,$dbpasswd,"insert into transaction (symbol, price, quantity, type, cashholding, email) values (?, ?, ?, ?, ?, ?)", undef, "cash", "0", "0", "cash", $cash, $user);};
    if ($@) {
    	print "there was an error";
    	} else {
    		print "<h2>Thanks for Registering!</h2>";
    		print "<a href=\"portfolio.pl\" class= \"btn\">Login!</a>";
    	}
    }
	}

	else {

    print "<div class='row'>";

    print "<div class='span6'>";
    print start_form(-name=>'Login', -type=>"post", -class=>"form-signin"),
    h2('Login'), "<fieldset>",
    hidden(-name=>'action',default=>['login']),
    textfield(-name=>'user', -placeholder=>'Name', -class=>'input-block-level'),"<br><br>",
    password_field(-name=>'password', -placeholder=>'Password', -class=>'input-block-level'), "<br><br>";
    print "<input type=\"submit\" class=\"btn btn-large btn-primary\">","</fieldset>";
    print "<br><br>";
    print "</form>";
    print "</div>
    <div class='span6'>
    ";
    print start_form(-name=>'Register', -type=>"post", -class=>"form-signin"),
    h2('Register'), "<fieldset>",
    textfield(-name=>'user', -placeholder=>'Name', -class=>'input-block-level'),"<br><br>",
    password_field(-name=>'password', -placeholder=>'Password', -class=>'input-block-level'), "<br><br>";
    print "<input type=\"submit\" class=\"btn btn-large btn-primary\">","</fieldset>";
    print "</div>";
    
    print "</div>";
	}
	require "footer.pl";
