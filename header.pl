#!/usr/bin/perl -w

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DBI;
use Time::ParseDate;
print "Content-type: text/html\n\n";

print "<html>";
print "<head>";
print "<title>Portfolio</title>";
print "</head>";

print "<body>";

print "<link href=\"\/\/netdna.bootstrapcdn.com\/twitter-bootstrap\/2.1.1\/css/bootstrap-combined.min.css\" rel=\"stylesheet\">";