#!/bin/sh
# (使い方) lowdown.sh sample lualatex
./lowdown -stlatex --parse-math --parse-hilite -o $1.tex $1.md 
$2 $1.tex
rm $1.log $1.aux $1.out
