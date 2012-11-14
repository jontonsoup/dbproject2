#!/usr/bin/perl -w
require "header.pl";

$stock = param("stock");

print "<img class=\"img\" src=\"http:\/\/murphy.wot.eecs.northwestern.edu\/~jmf716\/portfolio\/plot_stock.pl?type=plot&symbol=$stock\">";


require "footer.pl";