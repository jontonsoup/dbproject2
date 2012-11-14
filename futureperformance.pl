#!/usr/bin/perl -w
require "header.pl";
$symbol = param("stock");

print `time_series_symbol_project.pl ORCL 8 AWAIT 300 ARIMA 2 1 2 | tail -20 2>&1`;

require "footer.pl";