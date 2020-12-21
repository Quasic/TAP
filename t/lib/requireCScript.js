try{
WScript.stdout.write("#Verifying script host is cscript...\n");
}catch(e){
WScript.echo("TAP should be run in cscript, not WScript: "+e.message);
WScript.quit(255);
}
WScript.stdout.write("#Verified running in cscript.exe\n");
