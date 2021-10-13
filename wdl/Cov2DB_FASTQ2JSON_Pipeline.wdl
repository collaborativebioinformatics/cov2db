# Workflow Developer : Ramanandan Prabhakaran
# Step1: SRAIds are converted to R1 and R2 FASTQ files
# Step2: R1 and R2 FASTQ files are aligned against reference and to generate SAM files
# Step3: SAM files compressed to BAM files
# Step4: Variant calling performed on BAM files
# Step5: Compressing Variant Calling Files
# Step6: VCF files are converted to JSON

workflow Cov2DB_Preprocessing
{
	File sra_accession_file
	Int cpu
	Int memory
        Array[String] sra_entries = read_lines(sra_accession_file)
        File reference_file
        scatter (entry in sra_entries)
        {
		call SraToFastq { input: cpu=cpu, memory=memory, sra_id=entry }
		call FASTQ2SAM { input: cpu=cpu, memory=memory, sra_id=entry, R1_FASTQ=SraToFastq.r1_fastq, R2_FASTQ=SraToFastq.r2_fastq, reference_file = reference_file }
                call SAM2BAM { input: cpu=cpu, memory=memory, sra_id=entry, file=FASTQ2SAM.SAM_file }
                call BAM2VCF { input: cpu=cpu, memory=memory, BAM=SAM2BAM.BAM_file }
                call CompressVCF { input: cpu=cpu, memory=memory, sra_id=entry, VCF=BAM2VCF.VCF_file }
                call VCF2JSON { input: cpu=cpu, memory=memory, VCF=CompressVCF.VCF_file }
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

task FASTQ2SAM
{
     Int cpu
     Int memory
     String sra_id
     File R1_FASTQ
     File R2_FASTQ
     File reference_file
        command
        <<<
                echo "Aligning FASTQ files with the reference file to generate alignment file"
        >>>

        runtime
        {
                docker: ""
                cpu: "${cpu}"
                memory: "${memory}GB"
        }
        output
        {
                File SAM_file = "${sra_id}.sam"
        }

}

task SAM2BAM
{
     Int cpu
     Int memory
     String sra_id
     File SAM_file
        command
        <<<
           echo "Converting SAM to BAM format"
           samtools view -S -b ${SAM_file} > ${sra_id}.bam
        >>>

        runtime
        {
                docker: "rogerab/sam2bam:'latest"
                cpu: "${cpu}"
                memory: "${memory}GB"
        }
        output
        {
                File BAM_file = "${sra_id}.bam"
        }

}

task BAM2VCF
{
     Int cpu
     Int memory
     String sra_id
     File BAM_file
     File reference_file
        command
        <<<
           echo "Generating VCF from BAM file"
           freebayes -f ${reference_file} ${Bam_file} > ${sra_id}.vcf 
        >>>

        runtime
        {
                docker: "chrishah/freebays:v1.2.0-10-g8a0dbee"
                cpu: "${cpu}"
                memory: "${memory}GB"
        }
        output
        {
                File VCF_file = "${sra_id}.vcf"
        }

}

task CompressVCF
{
     Int cpu
     Int memory
     File VCF_file
        command
        <<<
           echo "Compressing VCF file"
           bgzip -c ${VCF_file} > ${VCF_file}.gz
           tabix -p vcf ${VCF_file}.gz
        >>>

        runtime
        {
                docker: "mgibio/tabix"
                cpu: "${cpu}"
                memory: "${memory}GB"
        }
        output
        {
                File VCF_file = "${VCF_file}.gz"
        }

}

task VCF2JSON
{
     Int cpu
     Int memory
     String sra_id
     File VCF_file
        command
        <<<
           echo "Converting VCF 2 JSON file"
           python3 vcf2json.py ${VCF_file} VCF2JSON_output
           echo "Conversion completed"
        >>>

        runtime
        {
                docker: "python:latest"
                cpu: "${cpu}"
                memory: "${memory}GB"
        }
        output
        {
                File JSON_file = "VCF2JSON_output/${sra_id}.chunk0.json"
        }

}

