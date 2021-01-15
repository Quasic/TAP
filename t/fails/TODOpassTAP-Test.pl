#!perl
use strict;
use warnings;
if(!eval{
require Test;
Test->import();
1;
}){
print"#TAP testing Test\n1..0 # Skipped: no Test module\n";
exit 0;
}
plan(tests=>1,todo=>[1]);
ok(1);
1;
