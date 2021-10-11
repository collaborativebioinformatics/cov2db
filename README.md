# covid_freq #subject to be changed

### Problem statement
BAM files storing low frequency info are not widely available, only consensus genomes / alleles. We would like to make a widely available resource for the community that is able to slurp in all low frequency/intrahost variant calls in an easy to use format (see VAPr for a similarly motivated approach).

### Project goal

### Figure scheme

------
### Idea to store
* SRA id (and bioproject)
  * assigned lineage/VOC of SRA sample
  * geographic location 
  * sample collection date
  * sequencing type (amplicon, shotgun, etc)
  * sequencing platform (ONT, Illumina, pacbio)
  * total number of reads

* VCF generation info
  * variant caller (program, iVar, lofreq, etc) 
  * version 
  * parameters

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

#### Users will likely want to know 
* I observed intrahost variant X, has this been previously observed? 
* Show me a histogram of frequency of intrahost variants across the reference (for all data in the database)
* filter by pvalue, min coverage, variant caller, etc
* link to phenotype info (i have a database of info I can share)
* do some set of intrahost variants for sample XYZ cover mutations specific to a VOC?

#### How to populate? Database without data is just a base
* Outside of this hackathon, my group and collaborators are running lofreq on all available SRAs (there are tons!)
* we need iVar and perhaps other methods too

#### How to incentivize data sharing of VCF files?
* make it easy to do (web interface for dropping in or command line tool for sharing or ?)
* make it clear what the goals are (to facilitate monitoring of intrahost variation on a global scale)
* create public facing interface where they can see their contributions
* explore possibility of resource publication and include all data contributors

------
### Team members
Todd Treangen (Team Lead) <br>
Ramanandan Prabhakaran, Roche Canada <br>
Li Chuin Chong, Twincore GmbH/HZI-DKFZ under auspices MHH <br>
Daniel Agustinho, Washington University <br>
Nick Sapoval, Rice University <br>
BaiWei Lo, University of Konstanz <br>
Maria Jose, Pondicherry Central University
