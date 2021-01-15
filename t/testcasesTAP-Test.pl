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
plan(tests=>6,todo=>[4,5]);
ok(1);
skip(1,0);
skip(1,1);
  ok(0);
  ok(0,1,'todo is fail');
ok(0,0);
1;
