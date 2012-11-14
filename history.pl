#!/usr/bin/perl -w
require "header.pl";
use Data::Dumper;
my $user = 'default';
my $pass = 'default';

my $login = cookie('login');

# This page allows users to see the past history of bought/sold stocks

print "
<h2>History</h1>
<h3>Record of Bought/Sold Stocks</h3>
";

# collects and tabulates history of transactions for current user
sub HistoryTable {
  
}

require "footer.pl";

