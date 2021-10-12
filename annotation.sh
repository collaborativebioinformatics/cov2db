for f in $(ls vcf_data/); do 
	java -jar -Xmx16G ../../snpEff/snpEff.jar NC_045512.2 vcf_data/$f > $f.ann.vcf; 
done