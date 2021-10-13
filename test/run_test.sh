# We need to get the cromwell server path
java -Dconfig.file=cromwell.conf -jar $CROMWELL run -i input.json ../wdl/Cov2DB_FASTQ2JSON_Pipeline.wdl
