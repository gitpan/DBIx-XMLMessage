#
#   DBIx::XMLMessage Sybase test
#

print "1..1\n";

use strict;
use DBI;
use DBIx::XMLMessage;

sub t1 { die @_; }
# sub t2 { print STDERR @_; }
sub t2 { }

# Template string
my $tpl_str =<< "_EOT_";
<?xml version="1.0" encoding="UTF-8" ?>
<TEMPLATE NAME='SysLogins' TYPE='XML' VERSION='1.0' TABLE='master..syslogins'>
  <KEY NAME='name' />
  <KEY NAME='status'  DATATYPE='NUMERIC' />
  <COLUMN NAME='name' />
  <COLUMN NAME='suId' EXPR='suid' DATATYPE='NUMERIC' />
</TEMPLATE>
_EOT_

my $msg = new DBIx::XMLMessage ('TemplateString' => $tpl_str,
        '_OnError' => \&t1, '_OnTrace' => \&t2 , '_OnDebug' => \&t2 );
# $DBIx::XMLMessage::TRACELEVEL = 1;
my $ghash = { 'name' => [ 'sa' ], 'status' => [ 1 ] };
my $dbh = DBI->connect('dbi:Sybase:server=__PUT_YOUR_OWN_DATASERVER_NAME_HERE__','sa','')
        || die $DBI::errstr;
$msg->rexec ($dbh, $ghash);
my $out = $msg->output_xml(0,0);
if ( $out =~ /\<name\>sa/ ) {
    print "ok\n";
} else {
    print "not ok\n";
}