#!/usr/bin/perl

use Getopt::Long;
use Time::ParseDate;
use FileHandle;

use stock_data_access;

$close=1;

$field='close';

&GetOptions("field=s" => \$field,
	    "from=s" => \$from,
	    "to=s" => \$to);

if (defined $from) { $from=parsedate($from);}
if (defined $to) { $to=parsedate($to); }


$#ARGV>=0 or die "usage: get_info.pl [--field=field] [--from=time] [--to=time] SYMBOL+\n";

#print join("\t","symbol","field","num","mean","std","min","max","cov"),"\n";

while ($symbol=shift) {
  #$sql = "select count($field), avg($field), stddev($field), min($field), max($field)  
  #        from ".GetStockPrefix()."StocksDaily where symbol='$symbol'
  #        ";
  $sql = "select count($field), avg($field), stddev($field), min($field), max($field) 
           from 
           (select symbol, close, timestamp from ".GetStockPrefix()."StocksDaily
           union all
           select symbol, close, ts as timestamp from stocksdaily)
           where symbol='$symbol'
          ";
  $sql.= " and timestamp>=$from" if $from;
  $sql.= " and timestamp<=$to" if $to;


  ($n,$mean,$std,$min,$max) = ExecStockSQL("ROW",$sql);

  $sql2 = "select regr_slope(close, max) from 
           (select symbol, close, timestamp from ".GetStockPrefix()."StocksDaily
            union all
            select symbol, close, ts as timestamp from stocksdaily)
            where symbol='$symbol'
            ";
  $sql2.= " and timestamp>=$from" if $from;
  $sql2.= " and timestamp<=$to" if $to;
             
         
  #$beta = ExecStockSQL("ROW",$sql2);
  $beta = 0;

  if ($n != 0) {
    print join("\t",$symbol,$field, $n, $mean, $std, $min, $max, $std/$mean ),"\n";
  } else {
    print "$n results\n";
  }
  
}
