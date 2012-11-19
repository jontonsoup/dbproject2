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

  if ($from && $to) {
    $sql2 = "select regr_slope(t1.close, t2.close) from
    (select close, timestamp from 
      (select symbol, close, timestamp from ".GetStockPrefix()."StocksDaily
        union all
        select symbol, close, ts as timestamp from stocksdaily)
        where symbol='$symbol' and timestamp>=$from and timestamp<=$to) t1
    join 
    (select avg(close) as close, timestamp from 
      (select symbol, close, timestamp from ".GetStockPrefix()."StocksDaily
       union all
       select symbol, close, ts as timestamp from stocksdaily)
      where timestamp>=$from and timestamp<=$to
      group by timestamp) t2
    on t1.timestamp = t2.timestamp
    ";
  
         
    $beta = ExecStockSQL("ROW",$sql2);
  

    print $beta,"\n";
  }
}
