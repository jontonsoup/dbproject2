#!/usr/bin/perl -w

use strict;
use CGI;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use DBI;
use Time::ParseDate;
print "Content-type: text/html\n\n";

print "<html>";
print "<head>";
print "<link href=\"\/\/netdna.bootstrapcdn.com\/twitter-bootstrap\/2.1.1\/css/bootstrap-combined.min.css\" rel=\"stylesheet\">";
print "<title>Portfolio</title>";
print "</head>";

print "<body>";

print "<div class=\"navbar navbar-inverse navbar-static-top\">
  <div class=\"navbar-inner\">
    <a class=\"brand\" href=\"#\">Portfolioliolio</a>
    <ul class=\"nav\">
      <li class=\"active\"><a href=\"#\">Home</a></li>
      <li><a href=\"#\">Link</a></li>
      <li><a href=\"#\">Link</a></li>
    </ul>
  </div>
</div>";

print "<div class=\"container\">";



print "<div class=\"hero-unit\">";