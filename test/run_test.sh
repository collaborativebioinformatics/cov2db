# Export the cromwell server path in the below line
# export CROMWELL=Enter the CROMWELL Installation Path:$CROMWELL 
java -Dconfig.file=cromwell.conf -jar $CROMWELL run -i input.json ../wdl/Cov2DB_FASTQ2JSON_Pipeline.wdl
