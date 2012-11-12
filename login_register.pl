if ($ENV{'REQUEST_METHOD'} eq "POST") {
	if (param('action') eq "login")
	{
		print "<h2>Thanks for logging in!</h2>";
		print "<a href=\"home.pl\" class= \"btn\">Go Home!</a>";
	}
	else {
		my $user = param("user");
		my $pass = param("password");
		my @rows;
		eval { ExecSQL($dbuser,$dbpasswd,"insert into stockuser (email, password, cash_holdings) values (?, ?, ?)", undef, $user, $pass, 100000);};
		if ($@) {
			print "there was an error";
			} else {
				print "<h2>Thanks for Registering!</h2>";
				print "<a href=\"home.pl\" class= \"btn\">Go Home!</a>";
			}
		}
	}

	else {

		print start_form(-name=>'Login', -type=>"post"),
		h2('Login!'), "<fieldset>",
		hidden(-name=>'action',default=>['login']),
		"Name: ",textfield(-name=>'user'),"<br><br>",
		"Password: ",password_field(-name=>'password'), "<br><br>";
		print "<input type=\"submit\" class=\"btn btn-primary\">","</fieldset>";

		print start_form(-name=>'Register', -type=>"post"),
		h2('Register!'), "<fieldset>",
		"Name: ",textfield(-name=>'user'),"<br><br>",
		"Password: ",password_field(-name=>'password'), "<br><br>";
		print "<input type=\"submit\" class=\"btn btn-primary\">","</fieldset>";

	}
	require "footer.pl";