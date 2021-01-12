/*
TAP format testcase library for JavaScript
by Quasic
released under Creative Commons Attribution (BY) 4.0 license
Please report bugs at https://github.com/Quasic/TAP/issues
*/
(function(){
var st=startTests=function(name,num,opts){
if(!opts)opts={};
if(!opts.write){
	if(typeof WScript!="undefined")opts.write=function(s){WScript.stdout.write(s+"\n");};
	else if(typeof console!="undefined"&&console.log)opts.write=console.log;
}
opts.write("#TAP testing "+name+
	" (TAP.js 1.0)")
if(!opts.exit){
	if(typeof WScript!="undefined")opts.exit=function(x){WScript.quit(x);};
	else opts.exit=function(x){opts.write("#Exit code: "+x)};
}
function x(x){
if(opts.exit)opts.exit(x);
return x;
}
if(num==="?"){
}else if(isNaN(parseInt(num))){
	opts.write("1..0 # Skipped: "+num);
	num=0;
}else{
	opts.write("1.."+(num*=1));
}
var ran=0,failed=0,skip=0,skipwhy,skiptype,pass,fail,O={
endTests:function(){
if(num==="?"){
	opts.write("1.."+ran);
}else if(num!=ran){
	opts.write("#Planned "+num+" tests, but ran "+ran+" tests");
	return 255;
}
return x(failed>254?254:failed);
},
bailOut:function(reason){
opts.write("Bail out!  "+reason);
x(255);
throw new Error(255,"255: TAP test "+name+" Bailed out! "+reason);
},
pass:pass=function(s){
	ran++;
	if(skip){
		skip--;
		if(skiptype=="TODO"){
			opts.write("ok "+ran+" - "+s+" # TODO "+skipwhy);
		}else{
			opts.write("ok "+ran+" # skip "+skipwhy);
		}
	}else{
		opts.write("ok - "+s);
	}
},
fail:fail=function(s,n){
	ran++;
	if(skip){
		skip--;
		if(skiptype=="TODO"){
			opts.write("not ok "+ran+" - "+s+" # TODO "+skipwhy+"\n#   Failed (TODO) test '"+s+"'");
		}else{
			opts.write("ok "+ran+" # skip "+skipwhy);
		}
	}else{
		failed++;
		opts.write("not ok - "+s);
		if(n){
			opts.write("#"+name+": "+n);
		}
	}
},
skip:function(why,n){
	if(skip){
		diag("skip called during "+skiptype+", nesting unsupported");
	}
	skip=n;
	skipwhy=why;
	skiptype="skip";
},
todo:function(why,n){
	if(skip){
		diag("todo called during "+skiptype+", nesting unsupported");
	}
	skip=n;
	skipwhy=why;
	skiptype="TODO";
},
diag:function(s){
	opts.write("#"+s.replace(/\n/,"\n#"));
},
subtest:function(name,num,f){
	if(skip&&skiptype=="skip")return pass(name);
	if(isNaN(parseInt(num))){
		opts.write("    1..0 #Skipped: "+num);
		return pass(name+" # Skip "+num);
	}
	var t=st(name,num,{write:function(s){opts.write("    "+s);},exit:function(x){if(x==255)O.bailOut("subtest bailed out");}});
	f(t);
	return O.is(t.endTests(),0,name);
},
okrun:function(fn,s){
	if(skip&&skiptype=="skip")return pass(s);
	try{
		return O.ok(fn(),s);
	}catch(e){
		fail(s);
		O.diag(e.message);
	}
},
ok:function(t,s){
if(t){
	pass(s);
}else{
	fail(s);
}
},
is:function(a,b,s){
if(a==b){
	pass(s);
}else{
	fail(s+", got "+a);
}
},
isIdentical:function(a,b,s){
if(a===b){
	pass(s);
}else{
	fail(s+", got "+a);
}
},
isnt:function(a,b,s){
if(a==b){
	fail(s+", got "+a);
}else{
	pass(s);
}
},
like:function(got,regex,s){
	if(got.match(regex))pass(s);
	else fail(s+", got "+got+", which didn't match "+regex);
},
unlike:function(got,regex,s){
	var m=got.match(regex);
	if(m)fail(s+", got "+got+" which matched "+regex+" for ("+m.join(")(")+")");
	else pass(s);
},
isDeeply:function(gotcx,excx,s){
	
},
can_ok:function(obj,methods){
	
}};
return O;
}})();
