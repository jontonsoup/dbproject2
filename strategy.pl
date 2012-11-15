#!/usr/bin/perl -w
use Data::Dumper;
require "header.pl";

$stock = param("stock");
print h2("Shannon Ratchet for $stock");
print start_form(-name=>'addmoney', -type=>"post"),
hidden(-name=>'stock', default=>[$stock]),
"Amount to start with : ", textfield(-name=>'amount'), "<br>",
"Trade cost : ", textfield(-name=>'tradecost'), "<br>",
"<input type=\"submit\" class=\"btn btn-primary\">";
 print "</form>";

if($ENV{'REQUEST_METHOD'} eq "POST") {
	my $amount = param("amount");
	my $tradecost = param("tradecost");
	print "<h2>Shannon Ratchet for $stock</h2>";
	@ret = `shannon_ratchet.pl $stock $amount $tradecost`;
	foreach $v (@ret){
		print $v, "<br>";
	}
}

require "footer.pl";