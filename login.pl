#!/usr/bin/perl -w

require "header.pl";


print start_form(-name=>'Login'),
h2('Login!'), "<fieldset>",
"Name: ",textfield(-name=>'user'),"<br><br>",
"Password: ",password_field(-name=>'password'), "<br><br>";
print "<input type=\"submit\" class=\"btn btn-primary\">","</fieldset>";

require "footer.pl";

