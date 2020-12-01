#!/bin/gawk -f
@include "./TAP.awk"
BEGIN{
startTests("bailoutTAP.awk",2)
bailout("test")
endTests()
}
