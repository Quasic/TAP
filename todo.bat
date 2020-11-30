@echo off
if '%TAPskip%'=='0' goto set
echo #todo called during %TAPskiptype%, nesting unsupported
:set
set TAPskipwhy=%1
set TAPskip=%2
set TAPskiptype=TODO
