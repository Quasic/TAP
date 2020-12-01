#!/bin/gawk -f
@include "./TAP.awk"
BEGIN{
startTests("gitscripts textconv awk failcases",1)
todo("TAP TODO test",1)
	pass("TAP dummy TODO pass")
endTests()
}
