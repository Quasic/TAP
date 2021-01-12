"use strict";
fso=new ActiveXObject("Scripting.FileSystemObject");
h=fso.openTextfile("TAP/TAP.js");
new Function(h.readAll())();
h.close();
t=startTests("skip test","skip test test");
t.endTests();
