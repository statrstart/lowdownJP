#!/bin/sh
./lowdown -stlatex --parse-math --parse-hilite --template ./share/latex/tategaki.latex -o $1.tex $1.md
$2 $1.tex
rm $1.log $1.aux $1.out
