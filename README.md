# covid_freq #subject to be changed

### Problem statement
VCF files storing low frequency info for SARS-CoV-2 are not widely available due to their size and limited downstream usage to date. However, there are over 1 million sequenced datasets in ENA/SRA from COVID-19 samples. The goal of this hackathon project is to create an easy to use database for the community that is able to store SARS-CoV-2 low frequency/intrahost variants.

### Workflow figure

![covid db workflow figure](https://github.com/collaborativebioinformatics/covid_freq/blob/main/coviddb_workflow.png)

------
### Idea to store source data (SRA id), reference genome, and VCF data
* ENA/SRA id (and bioproject)
  * assigned lineage/VOC of SRA sample
  * geographic location 
  * sample collection date
  * sequencing type (amplicon, shotgun, etc)
  * sequencing platform (ONT, Illumina, pacbio)
  * total number of reads

* Reference genome (wuhan)
  * accession
  * location of fasta
  * length/md5

* VCF variant alleles for SRA
  * variant type (SNV, etc)
  * variant position 
  * variant frequency
  * variant coverage
  * pvalue (if available)
  * synonymous/nonsynonymous mutation 
  * gene containing variant
  * variant caller (program, iVar, lofreq, etc) 
  * version 
  * parameters

#### Queries to support
* I observed intrahost variant X, has this been previously observed? 
* Show me a histogram of frequency of intrahost variants across the reference (for all data in the database)
* filter intrahost variants by pvalue, min coverage, variant caller, etc

------
### Team members
Todd Treangen (Team Lead) <br>
Nick Sapoval, Rice University (Team co-lead, data acquisition, writer) <br>
Ramanandan Prabhakaran, Roche Canada (Sysadmin, mongodb) <br>
Li Chuin Chong, Twincore GmbH/HZI-DKFZ under auspices MHH (Sysadmin, mongodb) <br>
Daniel Agustinho, Washington University (data acquisition, writer) <br>
BaiWei Lo, University of Konstanz (data acquisition, QC) <br>
Maria Jose, Pondicherry Central University (data acquisition, mongodb)
