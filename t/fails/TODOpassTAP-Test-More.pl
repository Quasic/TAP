#!perl
use strict;
use warnings;
if(!eval{
require Test::More;
Test::More->import(tests=>1);
1;
}){
print"#TAP testing Test::More\n1..0 # Skipped: no Test::More module\n";
exit 0;
}
TODO: {
  local $TODO='TODO pass test';
  pass('TODO pass');
  diag($TODO);
};
1;
