#!/bin/zsh

#
# USAGE: knitr.sh [filename.Rmd]
#

if [[ ! -r $1 ]]; then
    echo -e "\n File does not exist \n"
    return
fi

# create temporary rscript
tempscript=`mktemp /tmp/knitscript.XXXXX` || exit 1
echo "library(rmarkdown); rmarkdown::render('"${1}"', 'html_document')" >> $tempscript

cat $tempscript
Rscript $tempscript

