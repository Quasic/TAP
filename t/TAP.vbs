Set fso=CreateObject("Scripting.FileSystemObject")
set h=fso.openTextFile("TAP/TAP.vbs")
execute h.readAll()
h.close
set h=fso.openTextFile("t/lib/testcasesTAP.vbs")
execute h.readAll()
h.close
