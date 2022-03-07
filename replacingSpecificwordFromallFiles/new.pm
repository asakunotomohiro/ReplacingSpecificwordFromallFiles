package perlasakuno::replacingSpecificwordFromallFiles;
$VERSION = "0.001";
use v5.24;

package replacingSpecificwordFromallFiles::parent;
package mainProcess;
package new;
use Carp;
#our @ISA = qw();

sub help() {
	my $self = shift;
	# ここは、引数にヘルプの文言を付与された場合に呼び出される。

	say "引数にファイルを渡すこと。";
	say "\tファイル内容には、置換前の文字列と置換後の文字列が含まれていること。";
	say "\t置換対象は、''をプログラムファイルと同じ場所に作成しておくこと。";
	say "\tもし、作成しない場合のデフォルト(置換対象)：xxxxx";
	say "\tもし、作成しない場合のデフォルト(置換形式)：キャメル形式(1単語目の頭文字は小文字・2単語目以降の頭文字大文字)";
	say "\tファイル内容の1行名：検索対象。　※未実装(デフォルト値：xxx)";
	say "\tファイル内容の2行名：置換形式。　※未実装(デフォルト値：キャメル形式)";
	say "\tファイル内容の3行名：検索場所(当行0・前行-1・次行1など)。　※未実装(全て大文字になっている単語を取り出す。要は関数名)";
	say "\tファイル内容の4行名：読み込みファイル最大容量(ファイルを一度に読み込むため、メモリ枯渇を防ぐために最大MB数を指定する)。　※未実装";
	say "\t\t\tデフォルト値：ファイル最大容量上限なし。";
	say "以上。";
}

sub new() {
	no warnings 'experimental::smartmatch';
	# ユーザから渡されたファイルを全てハッシュに保存する。
	my $self = shift;
	my @argv = @_;
	my %filename = (
			option => {
				search => 'xxx',	# 検索対象(この単語を置き換える)
				type   => 'lcc',	# 置換形式(ローワキャメル形式)アッパーキャメル形式の場合はucc・スネーク形式sc
				place  => 1,		# 検索場所(次行)
				size   => 0,		# ファイル最大容量。
				hashNosize => 0,	# 自動取得(このハッシュの初期容量)。手動書き換え不可。
			},
		);	# これに保存する。
	$self = ref($self) || $self;
	#say "@argv";
	$filename{option}->{hashNosize} = keys %filename;
	#say $filename{option}->{hashNosize};

	my $argvOne;
	while( my( $index, $value ) = each ( @argv )) {

		if( -s -f $value ) {
			$filename{$index} = "$value";
			#say "$index, $value.";
		}
		else {
			if( defined $argvOne ) {
				# ここの処理が走る場合は、else文2回目の実行と言うこと。
				given ($argvOne) {
					when ('search')      { $filename{option}->{search} = $value }
					when ('type')        { $filename{option}->{type} = $value }
					when ('place')       { $filename{option}->{place} = $value }
					when ('size')        { $filename{option}->{size} = $value }
					when ('hashNosize')  { $filename{option}->{hashNosize} = $value }
#					default	{ say "その他の実行はない。" };
				};
			}
			$argvOne = $value;
		}
	}
	#say "$filename{0}";
	#say "$filename{1}";
	#say keys %filename;
	#my $size = keys %filename;
	#say $size;
	say '型：' . $filename{option}->{type};
	say 'hashNosize：' . $filename{option}->{hashNosize};

	bless \%filename, $self;
}

sub filenameShow() {
	# インスタンス生成で保存した引き数値を全て表示する。
	#	開発者用に作成したメソッド。
	my $self = shift;
	my @argv = @_;

	#say keys %$self;
	#say "$self->{0}";
	croak "引数にファイルを渡すこと。" unless defined(keys %$self);
	foreach my $key ( keys %$self ) {
		say "$key->$self->{$key}" unless ref $self->{$key};
	}
}


"以上。"
# vim: set ts=4 sts=4 sw=4 tw=0 ff=unix fenc=utf-8 ft=perl noexpandtab:
