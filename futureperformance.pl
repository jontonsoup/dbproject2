#!/usr/bin/perl -w
require "header.pl";

$stock = param("stock");

print h2("Predicted performance for $stock");
print start_form(-name=>'add time', -type=>"post"),
hidden(-name=>'stock', default=>[$stock]),
"Days to predict : ", textfield(-name=>'time'), "<br>",
"<input type=\"submit\" class=\"btn btn-primary\">";
print "</form>";

if($ENV{'REQUEST_METHOD'} eq "POST") {

	$time = param("time");
	print "<h2>Predicted performance for $stock</h2>";
	print "<img class=\"img\" src=\"http:\/\/murphy.wot.eecs.northwestern.edu\/~jmf716\/portfolio\/plot_future.pl?type=plot&symbol=$stock&time=$time\">";

	print "<br><iframe height=\"350\" src=\"http:\/\/murphy.wot.eecs.northwestern.edu\/~jmf716\/portfolio\/plot_future.pl?type=text&symbol=$stock&time=$time\"></iframe>";
}
require "footer.pl";