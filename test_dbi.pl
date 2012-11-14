#!/usr/bin/perl -w

use strict;
use CGI;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);

use DBI;
use DBI::Oracle

$database="cs339";
$platform="oracle";
$dbuser="gsi669";
$dbpasswd="z1OlkliU6";

# stopped cuz Max fixed it. FUCKING KEEP TRACK OF FUCKING ENVIRONMENT VARS.
