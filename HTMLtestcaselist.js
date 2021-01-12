function testcaselist(h){var o={
raw:"1..1\nok",
raw2:"1..2\nok\n#not ok\nnot ok # TODO test",
rawskip:"1..0 # Skipped as test",
runraw:function(w){w(o.raw)},
runraw2:function(w){w(o.raw2)},
runrawskip:function(w){w(o.rawskip)},
useTAPlib:function(w){
	var t=startTests("useTAPlib",1,{write:w});
	t.pass("useTAPlib pass");
	return t.endTests();
},
failsIntended:"1..1\nok\nnot ok\nnot ok - test # Skipped\nnot ok - blah\nok - #TODO reason",
bailoutIntended:"1..1\nBail out!  reason",
mismatchedPlansIntended:"1..1\nok\n1..4"
};return o;}
