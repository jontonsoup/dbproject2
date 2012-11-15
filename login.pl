#!/usr/bin/perl -w
require "header.pl";

if (!(cookie('login') eq undef)) {
  print "<a href=\"manage_portfolios.pl\" class= \"btn\">Manage Portfolios</a>";
}


#if ($ENV{'REQUEST_METHOD'} eq "POST") {
#}

else {

  print start_form(-name=>'Login', -type=>"post"),
  h2('Login!'), "<fieldset>",
  hidden(-name=>'action',default=>['login']),
  "Name: ",textfield(-name=>'user'),"<br><br>",
  "Password: ",password_field(-name=>'password'), "<br><br>";
  print "<input type=\"submit\" class=\"btn btn-primary\">","</fieldset>";


}
require "footer.pl";
