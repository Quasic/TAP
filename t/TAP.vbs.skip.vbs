Set fso=CreateObject("Scripting.FileSystemObject")
set h=fso.openTextFile("TAP/TAP.vbs")
execute h.readAll()
h.close
startTests WScript.stdout,"skip test","skip test test"
endTests