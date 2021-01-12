#!/bin/perl
=head1 VERSION

Version Alpha

=head1 Experiment

This was an experiment in an alternative simple way to handle file types, rather than using SourceHandlers, (I eventually figured out I could use my own SourceHandlers,) but I couldn't figure out a bug in the testcases. It worked for most practical testcases, though.

=head1 USAGE

TAPharness.pl [testlist]

Example:
TAPharness.pl TAP/lintTAP*.sh t/testcasesTAP*.*

=head1 BUGS

Unsolved bugs:

t/fails/bailoutTAP.tap was failing with code 25 instead of 255, only when run from t/testcasesTAPharness-fails.sh.

Even though this is experimental, you may report more bugs to https://github.com/Quasic/TAP/issues

=head1 LICENSE

Released under Creative Commons Attribution (BY) 4.0 license

=cut

use TAP::Harness;
exit 1 if ((TAP::Harness->new({
  color=>1,
  failures=>1,
  exec=>sub{
    my($harness,$f)=@_;
    return undef if$f=~/\.(plx?|pm)$/;
    return['bash',$f]if$f=~/\.(ba?|)sh$/;
    return['gawk','-f',$f]if$f=~/\.awk$/;
    if($f=~/\.ps1$/){
      $haspowershell=&which('powershell.exe')if!defined$haspowershell;
      return[$haspowershell,$f]if$haspowershell;
      return"#TAP testing $f\n1..0 #Skipped: no PowerShell\n";
    }
    if($f=~/\.(bat|cmd|nt)$/){
      $hasdos=&which(qw(cmd.exe command.com))if!defined$hasdos;
      return[$hasdos,'//c',$f]if$hasdos;
      return"#TAP testing $f\n1..0 #Skipped: no DOS\n";
    }
    if($f=~/\.bas$/){
      $hasbasic=&which(qw(qbasic basic))if!defined$hasbasic;
      return[$hasbasic,$f]if$hasbasic;
      return"#TAP testing $f\n1..0 #Skipped: no BASIC\n";
    }
    if($f=~/\.(vbs|wsf)$/){
      $hascscript=&which('cscript.exe')if!defined$hascscript;
      return['cscript','//nologo',$f]if$hascscript;
      return"#TAP testing $f\n1..0 #Skipped: no cscript\n";
    }
    if($f=~/\.js$/){
      $hasnode=&which('node')if!defined$hasnode;
      return['node',$f]if$hasnode;
      $hascscript=&which('cscript.exe')if!defined$hascscript;
      return['cscript','//nologo',$f]if$hascscript;
      return"#TAP testing $f\n1..0 #Skipped: no node or cscript\n";
    }
    #lua, python
    open my$h,"<$f"or return"#TAP testing $f\n1..1\nnot ok - failed to open $f\n";
    while(($_=<$h>)=~/^(#|1\.\.[0-9]|[\r\n])/){
      chomp;
      if(/^#!/){
        my$t=substr($_,2);
        if($t=~/^\//?-x $t:&which($t)){
          close$h;
          return[$t,$f];
        }else{
          print"$_ not executable in $f\n";
        }
      }
      if(/^(#TAP |1\.\.[0-9])/){
        seek($h,0,0);
        return$h;
      }
    }
    return"#TAP testing $f\n1..1\nnot ok - $f <not run: unknown extension, no hashbang or command not found, not raw TAP>\n";
  }
}))->runtests(@ARGV))->has_problems;
sub which{
my$q=join'||',map{"command -v $_"}@_;
$q=`bash -c '$q'`;
chomp($q);
return$q;
}