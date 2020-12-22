#!/bin/gawk -f
@include "./TAP/TAP.awk"
BEGIN{
startTests("bailoutTAP.awk",2)
bailout("test")
endTests()
}
