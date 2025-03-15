#!/bin/sh
./lowdown -stlatex --parse-math --parse-hilite -o temp.tex $1.md 
sed  -z "s/\n@\n\\\end{verbatim}\n\\\raggedright\n\\\renewcommand{\\\tcap}{}//g" temp.tex | sed -z "s/\\\if&\\\tcap&\\\else\\\centering\\\captionof{コード}{\\\tcap}\\\label{code:\\\tcap}\\\fi\n\\\begin{verbatim}\n@\n//g" > $1.tex
~/bin/$2 $1.tex
rm $1.log $1.aux $1.out temp.tex
