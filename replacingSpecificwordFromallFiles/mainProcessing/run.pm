package perlasakuno::replacingSpecificwordFromallFiles;
$VERSION = "0.001";
use v5.24;

package replacingSpecificwordFromallFiles::process;
package process;
use FindBin;

my $baseDir;
BEGIN { $baseDir = "$FindBin::Bin/.."; push @INC, $baseDir; require parent::new; }
#BEGIN { push @INC, "../parent" };	# セキュリティ上大丈夫か？
use Carp;
#require 'parent/new.pm';

#use parent::new;
#use local parent::new;
#use local::lib parent::new;
#use lib "${base_dir}"::parent::new;
#use lib "$base_dir/parent/new.pm";
#say $baseDir;
#use lib parent::new;

our @ISA = qw( mainProcess );

sub run() {
	my $self = shift;
	my $file = shift;

}
#&SUPER::help();
mainProcess::help();

"以上。"
# vim: set ts=4 sts=4 sw=4 tw=0 ff=unix fenc=utf-8 ft=perl noexpandtab:
