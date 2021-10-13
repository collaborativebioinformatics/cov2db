# Developer: Ramanandan Prabhakaran
# Bash script for compressing VCF files

#!/bin/bash

if [ $# -lt 1 ];  then
        echo "Usage: $(basename $0) <Input VCF Directory>"
        echo ""
        exit 1
fi

input_path=$1

for vcf in $(ls $input_path/*.vcf)
do
   echo "Compressing $vcf file"
   echo "gzip $vcf"
   gzip $vcf
   echo "Completed VCF compressing"
done
