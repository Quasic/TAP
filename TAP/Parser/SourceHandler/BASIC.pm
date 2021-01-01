package TAP::Parser::SourceHandler::BASIC;

use strict;
use warnings;

use TAP::Parser::IteratorFactory   ();
use TAP::Parser::Iterator::Process ();

use base 'TAP::Parser::SourceHandler::Executable';

TAP::Parser::IteratorFactory->register_handler(__PACKAGE__);

=head1 NAME

TAP::Parser::SourceHandler::BASIC - Stream TAP from a BASIC script

=head1 VERSION

Version 1

=head1 NOTES

If using a 16-bit BASIC, like QuickBASIC, paths will need converting using, for example, cygpath -ws. To ensure the bash subshell can find it, it is best to avoid functions or aliases:

$ printf '#!/bin/sh
/c/BASIC/QBASIC1.1/QBASIC.exe //run "$(cygpath -ws "$1")"
'>/usr/local/bin/basic
$ chmod +x /usr/local/bin/basic

=head1 BUGS

Report bugs to https://github.com/Quasic/TAP/issues

=head1 LICENSE

Released under Creative Commons Attribution (BY) 4.0 license

=cut

my$hasBASIC;

sub can_handle {
  my ( $class, $src ) = @_;
  my $meta = $src->meta;
  return 0 unless $meta->{is_file};
  my $file = $meta->{file};
  return 0 if$file->{shebang}=~/^#/;
  return 0.9 if $file->{lc_ext}eq'.bas';
}

sub make_iterator {
  my ( $class, $source ) = @_;
  my $meta        = $source->meta;
  my $script = ${ $source->raw };

  $class->_croak("Cannot find ($script)") unless $meta->{is_file};
  if(!defined$hasBASIC){
    $hasBASIC=`bash -c 'command -v basic'`;
    chomp($hasBASIC);
  }
  return TAP::Parser::Iterator::Array->new(["1..0 #Skipped: no BASIC found"])if!$hasBASIC;

  $class->_autoflush( \*STDOUT );
  $class->_autoflush( \*STDERR );

  return TAP::Parser::Iterator::Process->new(
      {   command  => ['basic',$script],
      }
  );
}
1;
