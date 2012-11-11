#!/usr/bin/perl -w
require "header.pl";

sub ValidUser {
	my ($user,$password)=@_;
	my @col;
	eval {@col=ExecSQL($dbuser,$dbpasswd, "select count(*) from stockuser where email='$user' and password='$password'",undef);};

	if ($@) {
		return 0;
		} else {
			return $col[0]>0;
		}
	}
	if ($ENV{'REQUEST_METHOD'} eq "POST") {
		print "<h2>Thanks for logging in!</h2>";
		print "<a href=\"home.pl\" class= \"btn\">Go Home!</a>";
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
