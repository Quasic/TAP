#!perl
use strict;
use warnings;
if(!eval{
require Test::More;
Test::More->import(skip_all=>'skip test test');
1;
}){
print"#TAP testing Test::More\n1..0 # Skipped: no Test::More module\n";
exit 0;
}
1;
