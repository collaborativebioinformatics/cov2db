![Visitor](https://visitor-badge.laobi.icu/badge?page_id=https://github.com/collaborativebioinformatics/cov2db)
# cov2db: a low frequency variant DB for SARS-CoV-2

## Problem

Global SARS-CoV-2 sequencing efforts have resulted in a massive genomic dataset available to the public for variety of analyses. However, the two most common resources are genome assemblies (e.g. deposited in GISAID and GenBank) and raw sequencing reads. Both of these limit the quantity of information, especially with respect to variants found within the SARS-CoV-2 populations. Genome assemblies only contain consensus level information, which is not reflective of the full genomic diveristy within a given sample (since even a single patient derived sample represents a viral population within the host). Raw sequencing reads on the other hand require further analyses in order to extract variant information, and can often be prohibitively large in size. 

Thus, we propose **cov2db** a database resource for collecting low frequency variant information for available SARS-CoV-2 data (currently there is more than 1.2 million SARS-CoV-2 sequencing datasets in SRA and ENA). Our goal is to provide an easy to use, query, and contribute to database of VCF files that contain variant calls for SARS-CoV-2 samples. We hope that such interactive database will speed up downstream analyses and encourage collaboration.

<!--- VCF files storing low frequency info for SARS-CoV-2 are not widely available due to their size and limited downstream usage to date. However, there are over 1.2 million sequenced datasets in ENA/SRA from COVID-19 samples, representing a unique opportunity to create a community resource for query and tracking intrahost viral evolution. The goal of this hackathon project is to create an easy to use database for the community that is able to store SARS-CoV-2 low frequency/intrahost variants. --->

## Team members
* Daniel Agustinho, Washington University (data acquisition, writer) <br>
* Li Chuin Chong, Twincore GmbH/HZI-DKFZ under auspices MHH (Sysadmin, mongodb) <br>
* Maria Jose, Pondicherry Central University (data acquisition, mongodb)
* BaiWei Lo, University of Konstanz (data acquisition, QC) <br>
* Ramanandan Prabhakaran, Roche Canada (Sysadmin, mongodb) <br>
* Nick Sapoval, Rice University (Team co-lead, data acquisition, writer) <br>
* Todd Treangen (Team Lead) <br>

## Related work
[VAPr](https://github.com/ucsd-ccbb/VAPr/) is an excellent mongodb based database for storing variant info. USCS SARS-CoV-2 genome broswers also provides visualization of intrahost variants [here](https://genome.ucsc.edu/cgi-bin/hgTracks?db=wuhCor1&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=NC_045512v2%3A1%2D29903&hgsid=1183075721_4GlEuE8o51gGamZyAQfT5UgwpPhq). 

## Workflow figure✍️
![covid_freq-Group6 (1)](https://user-images.githubusercontent.com/72709799/136825620-9f37b39e-0076-42ef-82fb-113b5a597e26.jpeg)


<img src="ZomboMeme 11102021113553.jpg" width="500">

------
## cov2db will contain the following information:
* ENA/SRA id (and bioproject)
- [ ] assigned lineage/VOC of SRA sample
- [ ] geographic location 
- [ ] sample collection date
- [ ] sequencing type (amplicon, shotgun, etc)
- [ ] sequencing platform (ONT, Illumina, pacbio)
- [ ] total number of reads

* Reference genome (wuhan)
- [ ] accession
- [ ] location of fasta
- [ ] length/md5

* VCF variant alleles for SRA
- [ ] variant type (SNV, etc)
- [ ] variant position 
- [ ] variant frequency
- [ ] variant coverage
- [ ] pvalue (if available)
- [ ] synonymous/nonsynonymous mutation 
- [ ] gene containing variant
- [ ] variant caller (program, iVar, lofreq, etc) 
- [ ] version 
- [ ] parameters

#### Queries to support
* Has intrahost variant V1 been previously observed? If so, when and where? 
* Show me a histogram of frequency of intrahost variants across the reference (for all data in the database)
* filter intrahost variants by pvalue, min coverage, variant caller, etc
