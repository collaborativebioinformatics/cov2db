
workflow SRA_FASTQ_Files_Fetcher_v1
{
	File sra_accession_file
	Int cpu
	Int memory
        Array[String] sra_entries = read_lines(sra_accession_file)
        scatter (entry in sra_entries)
        {
		call SraToFastq { input: cpu=cpu, memory=memory, sra_id=entry }
	}
}

task SraToFastq
{
	Int cpu
	Int memory
	String sra_id
	
	command
	<<<
		echo "Downloading ${sra_id}"
		fastq-dump --split-files --origfmt --gzip ${sra_id}		
	>>>
	runtime
	{
		docker:	"ummidock/sra-toolkit:latest"
		cpu: "${cpu}"
		memory:	"${memory}GB"
	}
	output
	{
		File r1_fastq = "${sra_id}_1.fastq.gz"
		File r2_fastq = "${sra_id}_2.fastq.gz"
	}
}

