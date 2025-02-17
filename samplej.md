title: lowdown（改）でLaTeX経由でpdfを作成してみた。
author: へのへの　もへじ
%date: 

%\pagestyle{empty}  % ページ番号をつけないようにする。
%\setcounter{secnumdepth}{-1}  % 章番号をつけないようにする。
%回り込み済んだら、\leavevmode
%注釈位置調整　\vspace*{\fill}
%マークダウン記法をカスタマイズする。 --- : 水平線を引く命令を改ページに変更済み
%マークダウン記法をカスタマイズする。（引数をひとつだけとる命令）
%\renewcommand{\emph}[1]{\ami{#1}}  %xelatex,lualatex:プリアンブルで設定済み(網掛け)
%\renewcommand{\Emph}[1]{\jkenten[s]{#1}}  %xelatex,lualatex:プリアンブルで設定済み（圏点）
%\renewcommand{\Textsuperscript}[1]{\WF{#1}}  %xelatex,lualatex:プリアンブルで設定済み(プリアンブルで定義した命令:図の回り込み）
%\renewcommand{\Textsubscript}[1]{\renewcommand{\tcap}{#1}}  %xelatex,lualatex:プリアンブルで設定済み(表につけるキャプション名)
% 使用頻度の高いlatexコマンド（引数をひとつだけとる命令）に対応させるようにマークダウン記法を変更できる
%\renewcommand{\SOUT}[1]{\highLight[yellow]{#1}}  %取り消し線をハイライトに変更(lualatexを使う場合)
%\renewcommand{\Textsuperscript}[1]{\shadowbox{#1}} 
%\renewcommand{\Textsubscript}[1]{\ovalbox{#1}} 
%\renewcommand{\Textsuperscript}[1]{\naka{#1}}  %プリアンブルで定義した命令（中揃え文字Large）
%\renewcommand{\Textsubscript}[1]{\migi{#1}}  %プリアンブルで定義した命令（右揃え文字large）

\section*{はじめに}

MarkdownをLaTeXに変換するソフトウェアは「pandoc」やその超拡張版ともいえる「Quarto」がよく知られています。ただ、ちょっとした文書やレポートを書くだけなのに
YAMLヘッダーで出力フォーマットだのなんだの指定するのが煩わしくなります。（個人的にはPDF一択なので）

で、他になにかいい感じのソフトがないかとgithubで探してみたら、[lowdown:simple markdown translator](https://github.com/kristapsdz/lowdown)を見つけました。
このソフト、プリアンブルはプログラム内に組み込むようになっています。ただ使用するdocumentclassがarticleなので、日本語の文章を書く場合は外部テンプレートを
読み込む必要があります。そこで、まず`latex.c`を書き換えて外部テンプレートを読み込むことなく日本語が使えるようにしてみました。（documentclass指定の
前にiftex.styを読み込み、処理系にpdflatex使用ならarticle、lualatexならltjsarticle、xelatexならbxjsarticleというように処理系に合わせてdocumentclassを変更する）
その他自分の使いやすいようにいろいろカスタマイズしました。（例えば、水平線を引く命令を改ページに変更、テーブルに罫線を引く等）

次に、`latex_escape.c`を書き換えて、LaTeX記法を認識するようにしました。それに伴い、LaTeX の「特殊文字」を書くときにはバッククォート (`` ` ``) で囲む、
 `% # $  & _ { } \ ^ ~` もしくは、 \% \\# \\$ \\& \\_ \\{ \\} \\\\ \\\^ \\\~　と書く必要があります。（書き方は、mdファイルを見てください。）

# 箇条書き

## 記号付き箇条書き

運動の法則

- 第一法則
	- 慣性の法則
- 第二法則 
	- 運動方程式 : ma＝F
- 第三法則
	- 作用反作用の法則

## 番号付き箇条書き

運動の法則

1. 第一法則
	- 慣性の法則
1. 第二法則
	- 運動方程式 : ma＝F
1. 第三法則
	- 作用反作用の法則

## 見出し付き箇条書き

運動の法則

　　第一法則
:	慣性の法則

　　第二法則
:	運動方程式 : ma＝F

　　第三法則
:	作用反作用の法則

## チェックボックス

- [ ] 慣性の法則
- [x] 運動方程式 : ma＝F
- [ ] 作用反作用の法則

# 引用環境

> 第一法則

> 第二法則
>> ma＝F

> 第三法則

# 脚注(footnote)

脚注は、`[^脚注名]`[^1]を使う。

[^1]: 脚注の内容

# 数式

マークダウンで数式を扱うには $\int^{\pi}_{0} \cos^2 (x)dx$ とするか、

$$\int^\pi_0 \cos ^2 (x)dx$$

とする。

# 図

![sin関数](fig1.pdf){width=50%}

# 文字の修飾の表

日本語の場合、英語と違って`イタリック`、`太字のイタリック`のマークダウン記法が無駄になります。
コマンドの定義、再定義によって`イタリック`は網掛けに、`太字のイタリック`は圏点にしてみました。

~文字の修飾の表~

|修飾          |  書き方   |   日本語             |
|:---------------:|:------------:|:-------------:|
|イタリックは網掛けに|  `*イタリックは網掛けに*`  | *イタリックは網掛けに*|
|太字        |  `**太字**`      |**太字**|
| 太字のイタリックは圏点に |`***太字のイタリックは圏点に***`|***太字のイタリックは圏点に***|
|\kintou{7}{取り消し線}           | `~~取り消し線~~` |~~取り消し線~~|
|アンダーライン|`==アンダーライン==`|==アンダーライン==|

また、上付き文字、下付き文字は数式モードを使えばすむことですので、やはりマークダウン記法が無駄になります。

（数式モードを使えば、下付き文字は `H$_2$O` H$_2$O、上付き文字は`$2^5$` $2^5$で表現できる。）

そこで、上付き文字、下付き文字は再定義してみました。

- 上付き文字（`^ファイル名^`） : 図の回り込み
- 下付き文字（`~キャプション名~`） : キャプション名を設定

但し、ファイル名、キャプション名ともスペースが使用できません。

# 図の回り込み

~雪だるま~

^snowman.pdf^
いいお天気でありました。
もはや、野にも山にも、雪が一面に真っ白くつもってかがやいています。
ちょうど、その日は学校が休みでありましたから、次郎は、家の外に出て、
となりの勇吉といっしょになって、遊んでいました。

「大きな、雪だるま\ref{fig:雪だるま}を一つつくろうね。」

二人は、こういって、いっしょうけんめいに雪を\ruby{一処}{ひとところ}にあつめて、
雪だるまをつくりはじめました。

# プログラムにキャプションをつける

~lowdownJP.sh~

```
#!/bin/sh
./lowdown -stlatex --parse-math --parse-hilite -o $1.tex $1.md 
$2 $1.tex
rm $1.log $1.aux $1.out
```

~lowdownでpdf作成~

```
./lowdownJP.sh samplej lualatex
```

~latexmkを使う場合~

```
./lowdownJP.sh samplej latexmk
```

~lowdownJP2.sh（外部テンプレートを使う）~

```
#!/bin/sh
./lowdown -stlatex --parse-math --parse-hilite --template ./share/latex/tategaki.latex -o $1.tex $1.md
$2 $1.tex
rm $1.log $1.aux $1.out
```

~外部テンプレートを使ってpdf作成~

```
./lowdownJP2.sh yukidaruma lualatex
```

---

# 段組み

\begin{multicols}{2}
\ruby{吾輩}{わがはい}は猫である。名前はまだ無い。

どこで生れたかとんと\ruby{見当}{けんとう}がつかぬ。
何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。
吾輩はここで始めて人間というものを見た。
しかもあとで聞くとそれは書生という人間中で一番\ruby{獰悪}{どうあく}な種族であったそうだ。
\end{multicols}

\leavevmode

# 枠付き文章

\begin{screen} 
\ovalbox{オイラーの公式($e^{i\theta}=\cos\theta+i\sin\theta$)}は，とても不思議
な式である．もともと，==幾何学的な意味を持つ**三角関数**と，解析的な**指数関数**が，
**虚数**を介して，とても単純な関係にある==ことを示している．
\end{screen}

# 相互参照

`\ref{fig:sin関数}`\ref{fig:sin関数}

`\ref{tbl:文字の修飾の表}`\ref{tbl:文字の修飾の表}

`\ref{code:外部テンプレートを使ってpdf作成}`\ref{code:外部テンプレートを使ってpdf作成}
