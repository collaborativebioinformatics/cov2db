# Developer: Ramanandan Prabhakaran
# Bash script for converting VCF files to json files required for MongoDB
# Dependency: Python3, compressed VCF
#!/bin/bash

if [ $# -lt 1 ];  then
        echo "Usage: $(basename $0) <Input VCF Directory>"
        echo ""
        exit 1
fi

input_vcf_path=$1

cd scripts_used_for_processing_VCF_2_JSON

for vcf in $(ls $input_vcf_path/*.vcf.gz)
do
   sample=$(basename $vcf | cut -d. -f 1)
   echo "Converting $vcf file to json file"
   echo "python3 vcf2json.py $vcf VCF2JSON_output"
   python3 vcf2json.py $vcf VCF2JSON_output
   echo "Conversion completed"
done
