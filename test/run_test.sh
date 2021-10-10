# We need to get the cromwell server path
java -Dconfig.file=cromwell.conf -jar $CROMWELL run -i input.json ../wdl/SRA_FASTQ_Files_Fetcher.wdl
