#!perl
if(!eval{
require Test::Simple;
Test::Simple->import(tests=>1);
1;
}){
print"#TAP testing Test::Simple\n1..0 # Skipped: no Test::Simple module\n";
exit 0;
}
ok(1,'TAP dummy pass');
#no TODO or skip in this module
1;
