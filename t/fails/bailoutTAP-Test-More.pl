#!perl
if(!eval{
require Test::More;
Test::More->import(tests=>1);
1;
}){
print"#TAP testing Test::More\n1..0 # Skipped: no Test::More module\n";
exit 0;
}
BAIL_OUT('TAP bailout test');
1;
