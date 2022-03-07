package perlasakuno::replacingSpecificwordFromallFiles;
BEGIN { push @INC, "." };	# セキュリティ上大丈夫か？
$VERSION = "0.001";
use v5.24;

package replacingSpecificwordFromallFiles::process;

package parent::process;
use Carp;
use File::Spec;

sub help() {
	my $self = shift;
	# ここは、引数にヘルプの文言を付与された場合に呼び出される。

	say "引数にファイルを渡すこと。";
	say "\tファイル内容には、置換前の文字列と置換後の文字列が含まれていること。";
	say "\t置換対象は、''をプログラムファイルと同じ場所に作成しておくこと。";
	say "\tもし、作成しない場合のデフォルト(置換対象)：xxx";
	say "\tもし、作成しない場合のデフォルト(置換形式)：キャメル形式(1単語目の頭文字は小文字・2単語目以降の頭文字大文字)";
	say "\tファイル内容の1行名：検索対象。　※未実装(デフォルト値：xxx)";
	say "\tファイル内容の2行名：置換形式。　※未実装(デフォルト値：キャメル形式)";
	say "\tファイル内容の3行名：検索場所(当行0・前行-1・次行1など)。　※未実装(全て大文字になっている単語を取り出す。要は関数名)";
	say "\tファイル内容の4行名：読み込みファイル最大容量(ファイルを一度に読み込むため、メモリ枯渇を防ぐために最大MB数を指定する)。　※未実装";
	say "\t\t\tデフォルト値：ファイル最大容量上限なし。";
	say "以上。";
}

my $pascalCase = sub{
	# スネーク形式をアッパーキャメル形式に変換する。
	#	例）ABC_DEF	⇒	AbcDef
	my @split = split /_/, shift;
	my $ret;
	foreach my $value ( @split ){
		# 頭文字のみ大文字。
		$ret .= "\u\L$value";
	}
	return $ret
};

my $camelcase = sub{
	# スネーク形式をローワキャメル形式に変換する。
	#	例）ABC_DEF	⇒	abcDef
	#my @split = split /_/, shift;
	#say "引数：@_";
	my $ret = $pascalCase->(@_);
#	while( my( $index, $value) = each ( @split ) ){
#		if( $index == 0 ) {
#			# 先頭単語は全て小文字。
#			$ret .= "\L$value";
#		}
#		else{
#			# 頭文字のみ大文字。
#			$ret .= "\u\L$value";
#		}
#	}
	"\l$ret"
};

sub new() {
	no warnings 'experimental::smartmatch';
	# ユーザから渡されたファイルを全てハッシュに保存する。
	my $self = shift;
	my @argv = @_;
	my %filename = (
			option => {
				search => 'xxx',	# 検索対象(この単語を置き換える)
				type   => 'lcc',	# 置換形式(ローワキャメル形式)アッパーキャメル形式の場合はucc・スネーク形式sc
				lcc    => $camelcase,	# ローワキャメル形式関数。
				ucc    => $pascalCase,	# アッパーキャメル形式関数。
				place  => 1,		# 検索場所(次行)
				size   => 0,		# ファイル最大容量。
				hashNosize => 0,	# 自動取得(このハッシュの初期容量)。手動書き換え不可。
				hashSize => 1,		# 自動取得(引数ファイル数)。手動書き換え不可。
			},
		);	# これに保存する。
	$self = ref($self) || $self;
	#say "@argv";
	$filename{option}->{hashNosize} = keys %filename;
	#say $filename{option}->{hashNosize};

	my $argvOne;
	while( my( $index, $value ) = each ( @argv )) {

		if( -s -f $value ) {
			#$value = File::Spec->rel2abs($value);
			$filename{$index} = "$value";
			#say "$index, $value.";
		}
		elsif( -z _ ) {
			warn "空ファイル($value)。";
		}
		else {
			if( defined $argvOne ) {
				# ここの処理が走る場合は、else文2回目の実行と言うこと。
				given ($argvOne) {
					when ('search')      { $filename{option}->{search} = $value if defined $value }
					when ('type')        { $filename{option}->{type} = $value if defined $value }
					when ('place')       { $filename{option}->{place} = $value if defined $value }
					when ('size')        { $filename{option}->{size} = $value if defined $value }
					#when ('hashNosize')  { $filename{option}->{hashNosize} = $value }
					when ('hashNosize')  { die '読み取り専用値を書き換えるな'; }
					#when ('hashSize')    { $filename{option}->{hashSize} = $value }
					when ('hashSize')    { die '読み取り専用値を書き換えるな'; }
#					default	{ say "その他の実行はない。" };
				};
			}
			$argvOne = $value;
		}
	}
	#say "$filename{0}";
	#say "$filename{1}";
	#say keys %filename;
	my $size = keys %filename;
	#say $size;
	#say '型：' . $filename{option}->{type};
	#say 'hashNosize：' . $filename{option}->{hashNosize};
	$filename{option}->{hashSize} = $size - $filename{option}->{hashNosize};

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

sub filecount() {
	# 引数に渡したファイル数を戻す。
	my $self = shift;

	return $self->{option}->{hashSize};
}

sub open() {
	# 引数のファイルを開く(1ファイルのみ)。
	my $self = shift;
	my $filename = shift;

	open my $file_fh, '<', $filename or die "$filenameのファイルオープン失敗($!)";
	return $file_fh;
}

sub filemove() {
	# 引数のファイル名を変更。
	my $self = shift;
	my $filename = shift;

	rename $filename, "$filename.bak";
}

sub write() {
	# 引数と同じ名前のファイルに書き込む。
	my $self = shift;
	my $filename = shift;	# ファイル名
	my $file = shift;		# ファイルの中身(リファレンス)

	#say $filename . "書き出しファイル名";
	open my $file_fh, '>', $filename or die "$filenameのファイルオープン失敗($!)";
	#say "書き出しデータ" . "@$file";
	foreach my $value ( @$file ) {
		chomp $value;
		print $file_fh $value;
	}
}


package mainProcess;
use Carp;

our @ISA = qw( parent::process );

sub run() {
	my $self = shift;

	while( my ($index, $filename) = each ( %$self ) ){
		if( -f $filename and -s _ >= $self->{option}->{size} ) {
		#say "$indexファイル：$filename" . %$self . -f $filename . "<";# . keys %$self;
		#if( -f $filename ){#and -s _ >= $self->{option}->{size} ) {
		#say "設定値：$self->{option}->{size}";
		#say -f $filename;
		#if( -s $filename >= $self->{option}->{size} ){#and ) {
		#if( "$index" ne "option" and -s $filename >= $self->{option}->{size} ) {
			#say "$index, $filename" . %$self;
		#if( "$index" ne "option"){# and -s $filename >= $self->{option}->{size} ) {
			#say "$index, $filename. -> " . %$self . -s _;
#			return;
			my $file_fh = $self->open($filename);
			my $type = "\L$self->{option}->{type}";
			my @file = <$file_fh>;
			foreach my $line ( 0 .. $#file ) {
				chomp $file[$line];
				# ファイル内容を1度に読み込むため、気をつけること。
				my $placeLine;	# ここに置換文字列を格納する。
				if( "$file[$line]" =~ /$self->{option}->{search}/ ) {
					#say "変更前：$file[$line]";
					$placeLine = $line + $self->{option}->{place};	# 置き換え対象行を保存する。
					#my $placeWord = $file[$placeLine] =~ s/ ([A-Z_]+) \{/\1/r;	# 関数名と思わしき単語を抜き出す(ここでは加工をしない)。
					my $placeWord = $file[$placeLine] =~ s/.* ([A-Z_]+) \{.*/\1/r;	# 関数名と思わしき単語を抜き出す(ここでは加工をしない)。
					#say "置換単語：$placeWord";
					chomp $placeWord;
					#say "置換単語：$file[$placeLine]";
					#say ref( $self->{option}->{$type} ) . "関数を呼び出したい$type";
					my $placeWord = $self->{option}->{$type}->($placeWord);	# 加工
					my $word = $file[$line] =~ s/$self->{option}->{search}/$placeWord/r;	# 既存行を置き換える。
					$file[$line] = $word;
					#say "変更後：<$placeWord>$word";
					#say "変更後：$file[$line]";
				}
			}
			close $file_fh;	# ファイルハンドル終了。
			$self->filemove($filename);	# 既存ファイルのバックアップ。
			#say "<@file>";
			#foreach my $line (@file) {
			#	say $line;
			#}
			$self->write($filename, \@file);	# 同名ファイルに吐き出し。
		}
	}
}


"以上。"
# vim: set ts=4 sts=4 sw=4 tw=0 ff=unix fenc=utf-8 ft=perl noexpandtab:
