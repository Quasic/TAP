T=startTests("testcasesTAPjs",23);
T.pass("TAP dummy pass");
T.skip("TAP dummy",4);
	T.pass("TAP dummy pass");
	T.fail("TAP dummy fail");
	T.okrun(function(){return false;},"okrun skip");
	T.subtest("subtest skip",1,function(t){
		t.bailOut("subtest skip");
	});
T.todo("TAP test",10);
	T.fail("TAP dummy todo fail");
	T.okrun(function(){return false;},"okrun fail");
	T.ok(false,"ok fail");
	T.is(5,6,"is fail");
	T.isnt(5,5,"isnt fail");
	T.like("abcde",/dc/,"like fail");
	T.unlike("test",/test/,"unlike fail");
	T.subtest("subtest fail",1,function(t){
		t.fail("subtest fail");
	});
	T.subtest("subtest pass 1/2",2,function(t){
		t.pass("subtest pass 1");
	});
	T.subtest("subtest pass 3/2",2,function(t){
		t.pass("subtest pass");
		t.is(5,5,"subtest is pass");
		t.isnt(5,6,"subtest isnt pass");
	});
T.okrun(function(){return true;},"okrun pass");
T.ok(true,"ok pass");
T.is(5,5,"is pass");
T.isnt(5,6,"isnt pass");
T.subtest("subtest in skip","skip test",function(t){
	t.bailOut("subtest pass");
});
T.subtest("subtest pass",1,function(t){
	t.pass("subtest pass");
});
T.subtest("subtest false",1,function(t){
	t.pass("subtest pass");
	return false;
});
T.subtest("subtest q","?",function(t){
	t.pass("subtest pass");
});
T.diag("testing diag\nnot ok - diag\nTAP tests END");
T.endTests();
