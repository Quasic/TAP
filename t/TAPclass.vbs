Set fso=CreateObject("Scripting.FileSystemObject")
set h=fso.openTextFile("TAP/TAPclass.vbs")
execute h.readAll()
h.close
set h=fso.openTextFile("t/lib/testcasesTAPclass.vbs")
execute h.readAll()
h.close
