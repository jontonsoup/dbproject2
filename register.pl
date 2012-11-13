#!/usr/bin/perl -w
require "header.pl";

if ($ENV{'REQUEST_METHOD'} eq "POST") {
  my $user = param("user");
  my $pass = param("password");
  my $cash = param("cash");
  my @rows;
  eval { ExecSQL($dbuser,$dbpasswd,"insert into stockuser (email, password) values (?, ?)", undef, $user, $pass);};
  if ($@) {
    print "there was an error";
  } else {
    print "<h2>Thanks for Registering!</h2>";
    print "<a href=\"portfolio.pl\" class= \"btn\">Login!</a>";
  }
}
else {

  print start_form(-name=>'Register', -type=>"post"),
  h2('Register!'), "<fieldset>",
  "Name: ",textfield(-name=>'user'),"<br><br>",
  "Password: ",password_field(-name=>'password'), "<br><br>",
  "Cash: ",textfield(-name=>'cash'),"<br><br>";
  print "<input type=\"submit\" class=\"btn btn-primary\">","</fieldset>";


}
require "footer.pl";
