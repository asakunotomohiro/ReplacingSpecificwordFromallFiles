package parent::process;
BEGIN { push @INC, "." };	# セキュリティ上大丈夫か？
$VERSION = "0.001";
use v5.24;
use Carp;
use File::Basename qw( fileparse );	# ファイルから色々取得。

sub help() {
	my $self = shift;
	# ここは、引数にヘルプの文言を付与された場合に呼び出される。

	say "引数にファイルを渡すこと。";
#	while( <DATA> ) {
#		print;
#	}
	say "\tファイル内容には、置換前の文字列と置換後の文字列が含まれていること。";
	say "\t置換対象は、'[ここにファイル名]'をプログラムファイルと同じ場所に作成しておくこと(未実装)。";
#	say "\tもし、作成しない場合のデフォルト(置換対象)：xxx";
#	say "\tもし、作成しない場合のデフォルト(置換形式)：キャメル形式(1単語目の頭文字は小文字・2単語目以降の頭文字大文字)";
#	say "\tファイル内容の1行名：検索対象(デフォルト値：xxx)。";
#	say "\tファイル内容の2行名：置換形式(デフォルト値：キャメル形式)。";
#	say "\tファイル内容の3行名：検索場所(当行0・前行-1・次行1など)。";
#	say "\tファイル内容の4行名：読み込みファイル最大容量。";
#	say "\t\t\t\tデフォルト値：ファイル最大容量上限なし(ファイルを一度に読み込むため、メモリ枯渇を防ぐために最大MB数を指定する)。";
#	say "\tファイル内容の5行名：拡張子を指定する(それ以外のファイルを除外)。指定する場合はピリオドも含めること。";
	say "以上。";
}

my $pascalCase = sub{
	# スネーク形式をアッパーキャメル形式に変換する。
	#	例）ABC_DEF	⇒	AbcDef
	my @split = split /_/, shift;
	my $ret;
	foreach my $value ( @split ){
		# 頭文字のみ大文字(のこりは小文字)。
		$ret .= "\u\L$value";
	}
	return $ret
};

my $camelcase = sub{
	# スネーク形式をローワキャメル形式に変換する。
	#	例）ABC_DEF	⇒	abcDef
	my $ret = $pascalCase->(@_);
	"\l$ret"	# 頭文字だけを小文字にする。
};

my $snakeCase = sub{
	# キャメル形式をスネーク形式に変換する。
	'未実装';
};

my $searchfunc = sub{
	# 設定値：検索単語。
	my $hash = shift;
	my $value = shift;

	if( defined $$value and $$value =~ /[^\w]/ ) {
		say "Perlでの識別子以外の文字設定不可：$$value";
	}
	else{
		# Perlでの識別子に限り、検索単語として利用する(本来やりたいことズレているが、そこまでの乖離はないだろう)。
		# ※マイナス数字なども不可になる。
		$hash->{option}->{search} = $$value;
	}
};

my $typefunc = sub{
	# 設定値：置換形式。
	my $hash = shift;
	my $value = shift;
	my @typeKey = qw( lcc ucc sc );	# この中に含まれている単語のみ許可する。
		# lcc	ローワキャメル形式
		# ucc	アッパーキャメル形式
		# sc	スネーク形式(未実装)

	my $special = $";	# バックアップ。
	$" = '|';
	if( defined $$value and "\L$$value" =~ /\L@typeKey/ ) {
		$hash->{option}->{type} = "\L$$value";
	}
	$" = $special;	# 戻す。
};

my $placefunc = sub{
	# 設定値：検索対象行。
	my $hash = shift;
	my $value = shift;

	if( defined $$value and $$value =~ /\d/ ) {
		$hash->{option}->{place} = $$value;
	}
};

my $filesizefunc = sub{
	# 設定値：ファイルサイズ。
	my $hash = shift;
	my $value = shift;

	if( defined $$value and $$value =~ /\d/ ) {
		$hash->{option}->{filesize} = $$value;
	}
};

my $extensionfunc = sub{
	# 設定値：拡張子。
	my $hash = shift;
	my $value = shift;

	if( defined $$value and $$value =~ /\A(\.\w+)+\z/ ) {
		$hash->{option}->{extension} = $$value;
	}
	else{
		say "拡張子指定はピリオドから始めること：$$value(また、Perlでの識別子以外も不可)";
		# 連続ピリオドの拡張子指定も不可(他にも制限があるかも？)。
	}
};

my $extensionPartition = sub {
	# 引数ファイルから必要な拡張子を持ったファイルを残し、他を削除する関数。
	my $self = shift;

	my $main = $self->{option}->{extension};	# オプションの中から拡張子を取り出す。
	return unless defined $main;	# 設定値がない場合、何もせずに終了する。
	while( my( $index, $value ) = each ( %$self ) ) {
		next if ref $value;
		# ファイル名を拡張子より前の部分・ディレクトリ部分・拡張子部分に分ける。
		my ( $basename, $dirname, $ext ) = fileparse($value, qr/\..*$/ );
		if( "\L$main" ne "\L$ext" ) {
			# 指定拡張子以外の場合、削除。
			delete $self->{$index};
		}
	}
};

sub new() {
	no warnings 'experimental::smartmatch';
	# ユーザから渡されたファイルを全てハッシュに保存する。
	my $self = shift;
	my @argv = @_;
	my %filename = (
			option => {	# オプション。
				search => 'xxx',		# 検索対象(この単語を置き換える)
				type   => 'lcc',		# 置換形式(ローワキャメル形式)アッパーキャメル形式の場合はucc・スネーク形式sc
				lcc    => $camelcase,	# ローワキャメル形式関数。
				ucc    => $pascalCase,	# アッパーキャメル形式関数。
				place  => 1,			# 検索場所(次行)
				filesize   => 0,		# ファイル最大容量。
				extension  => undef,	# 拡張子
				hashNosize => 0,		# 自動取得(このハッシュの初期容量)。手動書き換え不可。
				filecount  => 1,		# 自動取得(引数ファイル数)。手動書き換え不可。
			},
		);	# これに保存する。
	$self = ref($self) || $self;
	$filename{option}->{hashNosize} = keys %filename;

	my $argvOne;
	while( my( $index, $value ) = each ( @argv )) {
		# このループ処理は関数に追い出したい・・・。

		if( -s -f $value ) {
			$filename{$index} = "$value";
		}
		elsif( -d _ ) {
			# ディレクトリ
			#my $dir = dirname $value;
			#my ( $basename, $dirname, $ext ) = fileparse($value);
			#my $ext = $filename{option}->{extension};	# 拡張子の取り出し。
			#say "dir($value)：$dirname";
			#my @files = glob "$value/*$ext";
			#my @files = glob "$value/*";
			#say "ディレクトリ名：$value(ファイル群：@files)";
			#push @argv, @files;
			#push @argv, glob "$value/*";
			push @argv, <$value/*>;
			next;
		}
		elsif( -z _ ) {
			warn "空ファイル($value)。";
		}
		else {
			# この辺りは関数にまとめたい。
			if( defined $argvOne ) {
				# ここの処理が走る場合は、else文2回目の実行と言うこと。
				given ($argvOne) {
					when ('search')      { $searchfunc->( \%filename, \$value ); }	# 検索対象(この単語を置き換える)
					when ('type')        { $typefunc->( \%filename, \$value ); }	# 置換形式(ローワ・アッパー・キャメル形式・スネーク形式)
					when ('place')       { $placefunc->( \%filename, \$value ); }	# 検索場所(次行)
					when ('filesize')    { $filesizefunc->( \%filename, \$value ); }	# ファイル最大容量。
					when ('extension')   { $extensionfunc->( \%filename, \$value ); }	# 拡張子
					when ('hashNosize')  { die '読み取り専用値を書き換えるな'; }
					when ('filecount')   { die '読み取り専用値を書き換えるな'; }
#					default	{ say "その他の実行はない。" };
				};
			}
			$argvOne = $value;	# 1つ目の引数保存。
		}
	}
	my $size = keys %filename;
	$filename{option}->{filecount} = $size - $filename{option}->{hashNosize};	# 有効なファイル数の確認。
	$extensionPartition->(\%filename);	# 拡張子検査。

	bless \%filename, $self;
}

sub optionShow() {
	# インスタンス生成で保存したオプションを全て表示する。
	my $self = shift;
	my @argv = @_;
	my @notKey = qw( lcc ucc hashNosize );

	croak "引数にファイルを渡すこと。" unless defined(keys %$self);
	my $special = $";	# バックアップ。
	$" = '|';
	foreach my $key ( keys %{$self->{option}} ) {
		unless( $key =~ /@notKey/ ) {
			say "$key->$self->{option}->{$key}" unless ref $self->{$key};
		}
	}
	$" = $special;	# 戻す。
}

sub filenameShow() {
	# インスタンス生成で保存した引き数値を全て表示する。
	#	開発者用に作成したメソッド。
	my $self = shift;
	my @argv = @_;

	croak "引数にファイルを渡すこと。" unless defined(keys %$self);
	foreach my $key ( keys %$self ) {
		say "$key->$self->{$key}" unless ref $self->{$key};
	}
}

sub filecount() {
	# 引数に渡したファイル数を戻す。
	my $self = shift;

	return $self->{option}->{filecount};
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

	open my $file_fh, '>', $filename or die "$filenameのファイルオープン失敗($!)";
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

	warn "有効なファイルが存在しない。" . $self->help() unless $self->{option}->{filecount};
	while( my ($index, $filename) = each ( %$self ) ){
		if( -f $filename and -s _ >= $self->{option}->{filesize} ) {
			my $file_fh = $self->open($filename);
			my $type = "\L$self->{option}->{type}";
			my @file = <$file_fh>;
			foreach my $line ( 0 .. $#file ) {
				chomp $file[$line];
				# ファイル内容を1度に読み込むため、気をつけること。
				my $placeLine;	# ここに置換文字列を格納する。
				if( "$file[$line]" =~ /$self->{option}->{search}/ ) {
					$placeLine = $line + $self->{option}->{place};	# 置き換え対象行を保存する。
					my $placeWord = $file[$placeLine] =~ s/.* ([A-Z_]+) \{.*/\1/r;	# 関数名と思わしき単語を抜き出す(ここでは加工をしない)。
					chomp $placeWord;
					my $placeWord = $self->{option}->{$type}->($placeWord);	# 加工
					my $word = $file[$line] =~ s/$self->{option}->{search}/$placeWord/r;	# 既存行を置き換える。
					$file[$line] = $word;
				}
			}
			close $file_fh;	# ファイルハンドル終了。
			$self->filemove($filename);	# 既存ファイルのバックアップ。
			$self->write($filename, \@file);	# 同名ファイルに吐き出し。
			say "変換対象ファイル：$filename";
		}
	}
	say "以下、設定値。";
	$self->optionShow();
}


"以上。"
__DATA__
"\tファイル内容には、置換前の文字列と置換後の文字列が含まれていること。";
"\t置換対象は、'[ここにファイル名]'をプログラムファイルと同じ場所に作成しておくこと(以下、未実装)。";
"\tもし、作成しない場合のデフォルト(置換対象)：xxx";
"\tもし、作成しない場合のデフォルト(置換形式)：キャメル形式(1単語目の頭文字は小文字・2単語目以降の頭文字大文字)";
"\tファイル内容の1行名：検索対象(デフォルト値：xxx)。";
"\tファイル内容の2行名：置換形式(デフォルト値：キャメル形式)。";
"\tファイル内容の3行名：検索場所(当行0・前行-1・次行1など)。";
"\tファイル内容の4行名：読み込みファイル最大容量。";
"\t\t\tデフォルト値：ファイル最大容量上限なし(ファイルを一度に読み込むため、メモリ枯渇を防ぐために最大MB数を指定する)。";
__END__
# vim: set ts=4 sts=4 sw=4 tw=0 ff=unix fenc=utf-8 ft=perl noexpandtab:
