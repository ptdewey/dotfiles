#!/bin/bash

if [[ ! -r $1 ]]; then
    echo -e "File does not exist"
    return 1 2>/dev/null || exit 1
fi

tempscript=$(mktemp /tmp/knitscript.XXXXX) || { echo "Failed to create temp script"; return 1 2>/dev/null || exit 1; }

output_format=${2:-pdf} # Default to PDF

if [[ $output_format == "html" ]]; then
    echo "library(rmarkdown); rmarkdown::render('"${1}"', 'html_document')" >> $tempscript
else
    echo "library(rmarkdown); rmarkdown::render('"${1}"', 'pdf_document')" >> $tempscript
fi

cat $tempscript
if ! Rscript $tempscript; then
    echo "Failed to run Rscript"
    rm -f $tempscript
    return 1 2>/dev/null || exit 1
fi

rm -f $tempscript  # Clean up temporary script
