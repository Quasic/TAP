/*
TAPharness.js
for use by TAPharness.html
by Quasic
released under Creative Commons Attribution (BY) 4.0 license
Please report bugs at https://github.com/Quasic/TAP/issues
*/
function setuptests(container,lister){
	document.getElementById("versions").innerHTML=
		'; TAPharness.js 0.1';
	var bailed=/^[ \t]*Bail out!  /,plan=/^1..([0-9]+)/,tests=/^(not |)ok( [1-9][0-9]*|)( |$)/,directive=/ # *([Tt][Oo][Dd][Oo]|[Ss][Kk][Ii][Pp])/;
	function run(fn,m,o){
		var r,d,n=0,fails=0,actual={ok:0,not:0},todopassed=0,skips=0,todos=0,planNum="?",parseErrs="",
			s=function(s){
				var b=false,l,t,i,j,a=s.split("\n");
				for(i=0;i<a.length;i++){
					l=document.createElement("li");
					l.appendChild(document.createTextNode(a[i]));
					o.appendChild(l);
					if(a[i].substring(0,1)=="#"){
						l.className="comment";
					}else if(t=a[i].match(plan)){
						l.className="plan";
						if(planNum=="?"){
							planNum=t[1];
						}else if(planNum!=t[1]){
							l.className+=" parseErr";
							parseErrs+=" Conflicting plans (was "+planNum+" tests, but found "+a[i]+")";
						}
					}else if(t=a[i].match(tests)){
						n++;
						actual[t[1]?"not":"ok"]++;
						l.className="test actual"+(t[1]?"fail":"pass");
						if(+t[2]&&t[2]!=n){
							l.className+=" parseErr";
							parseErrs+=" Expected test # "+n+", but found test # "+t[2];
						}
						if(j=a[i].match(directive))j[1]=j[1].toLowerCase();
						else j=["",""];
						if(j[1]=="todo"){
							todos++
							if(t[1]==""){
								fails++;
								todopassed++;
								l.className+=" fail todopass";
							}else l.className+=" pass todofail"
						}else if(j[1]=="skip"){
							skips++;
							if(t[1]){
								fails++;
								l.className+=" fail skipfail";
							}
						}else if(t[1]){
							fails++;
							l.className+=" fail";
						}else l.className+=" pass";
					}else if(a[i].match(bailed)){
						l.className="bailout";
						b=a[i];
					}
				}
				if(b)throw new Error(255,"255: Bailout called in: "+b);
			};
		d=new Date();
		try{
			r=typeof fn=="string"?s(fn):r=fn(s);
		}catch(e){
			r=e.description;
		}
		m.innerHTML=""
		m.appendChild(document.createTextNode(": Ran in "+(new Date()-d)+" ms (returned: '"+r+"', parsed "+n+" tests"+(n!=planNum?" (expected "+planNum+"!)":"")+", failed "+fails+" (passed "+todopassed+" TODOs), actual{"+actual.not+" passed, "+actual.ok+" failed}, skipped "+skips+", "+todos+" todos"+(parseErrs?" with error:"+parseErrs:"")+")"));
		m.className=r||fails||parseErrs||n!=planNum?"fail":"pass";
		d=document.createElement("span");
		d.className="button";
		d.appendChild(document.createTextNode("Show/Hide"));
		d.onclick=function(){
			if(o.style.display=="none")o.style.display="";
			else o.style.display="none";
		};
		m.appendChild(d);
		r=document.createElement("span");
		r.className="button";
		r.appendChild(document.createTextNode("Rerun"));
		r.onclick=function(){
			o.innerHTML="";
			run(fn,m,o);
		};
		return r;
	}
	var t=lister(),e,b,l,m,R=[];
	for(var i in t){
		e=document.createElement("div");
		e.appendChild(document.createTextNode(i));
		m=document.createElement("span");
		e.appendChild(m);
		l=document.createElement("ol");
		l.style.display="none";
		e.appendChild(l);
		container.appendChild(e);
		run(t[i],m,l);
	}
}
