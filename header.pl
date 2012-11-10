#!/usr/bin/perl -w

#
#


#
# Debugging
#
# database input and output is paired into the two arrays noted
#
my $debug=1; # default - will be overriden by a form parameter or cookie
my @sqlinput=();
my @sqloutput=();
use strict;
use CGI qw(:standard);
use DBI;
use Time::ParseDate;

# my $dbuser="jmf716";
# my $dbpasswd="RR62rwno";


# my $cookiename="RWBSession";
# #
# # And another cookie to preserve the debug state
# #
# my $debugcookiename="RWBDebug";

# #
# # Get the session input and debug cookies, if any
# #
# my $inputcookiecontent = cookie($cookiename);
# my $inputdebugcookiecontent = cookie($debugcookiename);

# #
# # Will be filled in as we process the cookies and paramters
# #
# my $outputcookiecontent = undef;
# my $deletecookie=0;
# # get the user action and whether he just wants the form or wants us to
# # run the form
# #
# my $action;
# my $run;


# $outputdebugcookiecontent=$debug;



# my @outputcookies;


# if (defined($outputcookiecontent)) {
# 	my $cookie=cookie(-name=>$cookiename,
# 		-value=>$outputcookiecontent,
# 		-expires=>($deletecookie ? '-1h' : '+1h'));
# 	push @outputcookies, $cookie;
# }


print header(-expires=>'now');

print "<html>";
print "<head>";
print "<title>Red, White, and Blue</title>";
print "</head>";

print "<body>";

print "<link href=\"\/\/netdna.bootstrapcdn.com\/twitter-bootstrap\/2.1.1\/css/bootstrap-combined.min.css\" rel=\"stylesheet\">";