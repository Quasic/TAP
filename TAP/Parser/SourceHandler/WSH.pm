package TAP::Parser::SourceHandler::WSH;

use strict;
use warnings;

use TAP::Parser::IteratorFactory   ();
use TAP::Parser::Iterator::Process ();

use base 'TAP::Parser::SourceHandler::Executable';

TAP::Parser::IteratorFactory->register_handler(__PACKAGE__);

=head1 NAME

TAP::Parser::SourceHandler::WSH - Stream TAP from a Windows Script Host script

=head1 VERSION

Version 1

=head1 SHEBANGS

To remove ambiguity when using WSH/JScript and node.js or other hosts/engines together, please use one of the following "shebang wrappers":

For JScript:
//#![/path/to/]cscript.exe [options]
or
/*#![/path/to/]cscript.exe [options] */
or multiline with comments
/*#![/path/to/]cscript.exe [options]
[comments]
*/

For VBScript:
'#![/path/to/]cscript.exe [options]
or
Rem #![/path/to/]cscript.exe [options]

For .wsf:
<!--#![/path/to/]cscript.exe [options] -->
or multiline with comments
<!--#![/path/to/]cscript.exe [options]
[comments]
-->

If the file doesn't have a .wsf extension and there is no //Job:... parameter, //Job:test will be used.

=head1 BUGS

Report bugs to https://github.com/Quasic/TAP/issues

=head1 LICENSE

Released under Creative Commons Attribution (BY) 4.0 license

=cut

my$hasCScript;

sub can_handle {
  my ( $class, $src ) = @_;
  my $meta = $src->meta;
  return 0 unless $meta->{is_file};
  my $file = $meta->{file};
  return 0.9 if $file->{shebang}=~/^('|\/\/|\/*|[Rr][Ee][Mm] |<!--)#!(.*\/|)cscript\.exe( |$)/;
  return 0.9 if $file->{lc_ext}=~/^\.(wsf|vbs)$/;
  return 0.75 if $file->{lc_ext}eq'.js';
}

sub make_iterator {
  my ( $class, $source ) = @_;
  my $meta        = $source->meta;
  my $script = ${ $source->raw };

  $class->_croak("Cannot find ($script)") unless $meta->{is_file};
  if(!defined$hasCScript){
    $hasCScript=`bash -c 'command -v cscript.exe'`;
    chomp($hasCScript);
  }
  return TAP::Parser::Iterator::Array->new(["1..0 #Skipped: no CScript.exe found"])if!$hasCScript;

  $class->_autoflush( \*STDOUT );
  $class->_autoflush( \*STDERR );

  if($meta->{file}->{shebang}=~/^('|\/\/|\/*|[Rr][Ee][Mm] |<!--)#!(.*\/|)cscript\.exe(| .*)$/){
    $2.='cscript.exe';
    my$p= -f $2?"$2 $3":"$hasCScript $3";
    my@m;
    $p.=' //B'if$p!~/\/I( |\t|$)/i;
    $p.=' //Nologo'if$p!~/\/(no|)logo( |\t|$)/i;
    if('//'eq$1){
      $p.=' //E:JScript'if$p!~/\/E:/i;
    }elsif('/*'eq$1){
      $p=$1 if$p=~/^(.*)[ \t]*\*\//;
      $p.=' //E:JScript'if$p!~/\/E:/i;
    }elsif($1=~/^('|[Rr][Ee][Mm] )$/){
      $p.=' //E:VBScript'if$p!~/\/E:/i;
    }elsif('<!--'eq$1){
      $p=$1 if$p=~/^(.*)[ \t]*-->/;
      $p.=' //Job:test'unless$p=~/\/Job:/i||$meta->{file}->{lc_ext}eq'.wsf';
    }else{
      return TAP::Parser::Iterator::Array->new(['Bail out!  internal error in '.__PACKAGE__]);
    }
    @m=split($p,/[ \t]+/);
    push(@m,$script);
    return TAP::Parser::Iterator::Process->new({command=>\@m});
  }else{
    return TAP::Parser::Iterator::Process->new(
        {   command  => [$hasCScript,'//nologo',$script],
        }
    );
  }
}
1;
