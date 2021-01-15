#!perl
use strict;
use warnings;
if(!eval{
require Test::More;
Test::More->import(tests=>4);
1;
}){
print"#TAP testing Test::More\n1..0 # Skipped: no Test::More module\n";
exit 0;
}
pass('TAP dummy pass');
SKIP: {
  skip('skip test',2);
  pass('skip pass');
  fail('skip fail');
};
TODO: {
  local $TODO='fails';
  fail('todo fail');
  diag($TODO);
};
1;
