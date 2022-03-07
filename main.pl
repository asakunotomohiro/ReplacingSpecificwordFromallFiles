package perlasakuno::replacingSpecificwordFromallFiles;
$VERSION = "0.001";
use v5.24;

package replacingSpecificwordFromallFiles::main;
BEGIN { push @INC, "."; };	# セキュリティ上大丈夫か？
#BEGIN { push @INC, "./replacingSpecificwordFromallFiles/parent/"; };	# セキュリティ上大丈夫か？
#use replacingSpecificwordFromallFiles::mainProcessing::open;
#use replacingSpecificwordFromallFiles::parent;
#use replacingSpecificwordFromallFiles;
#use replacingSpecificwordFromallFiles::parent::new;#	なぜ、これがエラーになる？	←☆解消された。
#use replacingSpecificwordFromallFiles::new;#	なぜ、これがエラーになる？	←☆解消された。
#use replacingSpecificwordFromallFiles::mainProcess;#	なぜ、これがエラーになる？	←☆解消された。
use replacingSpecificwordFromallFiles::mainProcessing;#	なぜ、これがエラーになる？	←☆解消された。
#use parent;
#require 'replacingSpecificwordFromallFiles::parent::new.pm';
#require replacingSpecificwordFromallFiles::parent::new;
#require 'new.pm';	# パッケージが全く分からない。

sub main() {
	# ユーザから渡されたファイルを別途保存する。
	#my $object = replacingSpecificwordFromallFiles::parent->new();
	#my $object = replacingSpecificwordFromallFiles::parent::new->new();
	#my $object = replacingSpecificwordFromallFiles->new();
	#my $object = new();
	#my $object = new->new();
	#my $object = parent->new();
	#my $object = mainProcess->new(@ARGV);
	#my $object = run->new(@ARGV);
	#my $object = run->new(@ARGV);
	my $object = mainProcess->new(@ARGV);
	$object->help() unless @ARGV;
	#my $object = replacingSpecificwordFromallFiles::parent->new();
	$object->filenameShow();
	say $object->filecount();
	$object->run();
}
&main(@ARGV);


"以上。"
# vim: set ts=4 sts=4 sw=4 tw=0 ff=unix fenc=utf-8 ft=perl noexpandtab:
