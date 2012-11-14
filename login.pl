#!/usr/bin/perl -w
require "header.pl";


if ($ENV{'REQUEST_METHOD'} eq "POST") {
  print "<h2>Thanks for logging in!</h2>";
  print "<a href=\"portfolio.pl\" class= \"btn\">Go Home!</a>";
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
