"use strict";
//use require for node
fso=new ActiveXObject("Scripting.FileSystemObject");
h=fso.openTextfile("TAP/TAP.js");
new Function(h.readAll())();
h.close();
h=fso.openTextFile("t/lib/testcasesTAP.js");
new Function(h.readAll())();
h.close();
