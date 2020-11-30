function startTests(write,name,num){
function w(s){write(s+"\n");}
function x(x){
if(typeof WScript!="undefined")WScript.quit(x);
return x;
}
w("#TAP testing "+name)
if(isNaN(parseInt(num))){
	w("1..0 # Skipped: "+num);
	num=0;
}else{
	w("1.."+(num*=1));
}
var ran=0,failed=0,skip=0,skipwhy,skiptype,O={
endTests:function(){
if(num!=ran){
	w("#Planned "+num+" tests, but ran "+ran+"tests");
	return 255;
}
return x(failed>254?254:failed);
},
bailOut:function(reason){
w("Bail out!  "+reason);
return x(255);
},
pass:function(s){
	ran++;
	if(skip){
		skip--;
		if(skiptype=="TODO"){
			w("ok "+ran+" - "+s+" # TODO "+skipwhy);
		}else{
			w("ok "+ran+" # skip "+skipwhy);
		}
	}else{
		w("ok - "+s);
	}
},
fail:function(s,n){
	ran++;
	if(skip){
		skip--;
		if(skiptype=="TODO"){
			w("not ok "+ran+" - "+s+" # TODO "+skipwhy+"\n#   Failed (TODO) test '"+s+"'");
		}else{
			w("ok "+ran+" # skip "+skipwhy);
		}
	}else{
		failed++;
		w("not ok - "+s);
		if(n){
			w("#"+name+": "+n);
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
	w("#"+s);
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
isnt:function(a,b,s){
if(a==b){
	fail(s+", got "+a);
}else{
	pass(s);
}
},
like:function(got,regex,s){
	
},
unlike:function(got,regex,s){
	
},
isDeeply:function(gotcx,excx,s){
	
},
can_ok:function(obj,methods){
	
}};
return O;
}
