package perlasakuno::replacingSpecificwordFromallFiles;
$VERSION = "0.001";
use v5.24;

package replacingSpecificwordFromallFiles::process;
package open;
use Carp;
our @ISA = qw( mainProcess );

sub open() {
	my $self = shift;
	my $filename = shift;

	open my $file_fh, '<', $filename or die "$filenameのファイルオープン失敗($!)";
}


"以上。"
# vim: set ts=4 sts=4 sw=4 tw=0 ff=unix fenc=utf-8 ft=perl noexpandtab:
