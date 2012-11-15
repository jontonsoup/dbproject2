#!/usr/bin/perl -w
require "header.pl";

$stock = param("stock");

print "<h2>History for $stock</h2>";
print "<img class=\"img\" src=\"http:\/\/murphy.wot.eecs.northwestern.edu\/~jmf716\/portfolio\/plot_future.pl?type=plot&symbol=$stock\">";

print "<br><iframe height=\"350\" src=\"http:\/\/murphy.wot.eecs.northwestern.edu\/~jmf716\/portfolio\/plot_future.pl?type=text&symbol=$stock\"></iframe>";

require "footer.pl";