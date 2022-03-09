package replacingSpecificwordFromallFiles::main;
$VERSION = "0.002";
use v5.24;

BEGIN { push @INC, "."; };	# セキュリティ上大丈夫か？
use replacingSpecificwordFromallFiles::mainProcessing;

sub main() {
	# ユーザから渡されたファイルを別途保存する。
	my $object = mainProcess->new(@ARGV);
	$object->help() unless @ARGV;
	#$object->filenameShow();
	#say $object->filecount();
	#say '-' x 30;
	#$object->optionShow();
	#say '-' x 30;
	#$object->run();
	$object->optionWrite();
	$object->optionRead();
}
&main(@ARGV);


"以上。"
# vim: set ts=4 sts=4 sw=4 tw=0 ff=unix fenc=utf-8 ft=perl noexpandtab:
