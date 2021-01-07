#!/usr/bin/gawk -f
@include "./TAP/TAP.awk"
BEGIN{
startTests("gitscripts textconv awk testcases",4)
pass("TAP dummy pass")
skip("TAP test",2)
	pass("TAP dummy pass")
	fail("TAP dummy fail")
todo("TAP TODO test",1)
	fail("TAP dummy TODO fail")
diag("TAP tests END")
endTests()
}
