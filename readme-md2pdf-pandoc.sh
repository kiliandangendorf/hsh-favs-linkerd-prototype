#!/bin/bash
echo "generating pdf from README.md"
pandoc --metadata-file=readme-md2pdf-pandoc-header.yaml --listings -o readme.pdf README.md
