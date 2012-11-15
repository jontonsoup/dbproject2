#!/usr/bin/perl -w
require "header.pl";

$stock = param("stock");
print h2("Select a history interval for $stock");

print start_form(-name=>'add_time', -type=>"post"),
hidden(-name=>'stock', default=>[$stock]),
radio_group(-name=>'interval', -values=>['Daily', 'Weekly', 'Monthly', 'Yearly']), "<br>",
"<input type=\"submit\" class=\"btn btn-primary\">";
print "</form>";

if($ENV{'REQUEST_METHOD'} eq "POST") {

	$interval = param("interval");

	print "<h2>History for $stock</h2>";
	print "<img class=\"img\" src=\"http:\/\/murphy.wot.eecs.northwestern.edu\/~jmf716\/portfolio\/plot_stock.pl?type=plot&symbol=$stock&interval=$interval\">";

	print "<br><iframe height=\"350\" src=\"http:\/\/murphy.wot.eecs.northwestern.edu\/~jmf716\/portfolio\/plot_stock.pl?type=text&symbol=$stock&interval=$interval\"></iframe>";

}
require "footer.pl";