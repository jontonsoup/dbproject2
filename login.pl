#!/usr/bin/perl -w
require "header.pl";
use Data::Dumper;

if ($ENV{'REQUEST_METHOD'} eq "POST") {
	my $user = param("user");
	my $pass = param("password");
	my @rows;
	eval { @rows = ExecSQL($dbuser,$dbpasswd,"insert into stockuser (email, password) values ('$user', '$pass')");};
}

else {

	print start_form(-name=>'Login', -type=>"post"),
	h2('Login!'), "<fieldset>",
	"Name: ",textfield(-name=>'user'),"<br><br>",
	"Password: ",password_field(-name=>'password'), "<br><br>";
	print "<input type=\"submit\" class=\"btn btn-primary\">","</fieldset>";


}
require "footer.pl";
