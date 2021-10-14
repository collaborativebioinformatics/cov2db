![Visitor](https://visitor-badge.laobi.icu/badge?page_id=https://github.com/collaborativebioinformatics/cov2db)
# cov2db: a low frequency variant DB for SARS-CoV-2

![cov2db_logo_bg](https://user-images.githubusercontent.com/9452819/137010749-a6bebcbd-ddb6-4b0b-900e-a85fe9125c59.png)
(SARS-CoV-2 Illustration image credit: Davian Ho for the [Innovative Genomics Institute](https://innovativegenomics.org/free-covid-19-illustrations/))

-----

## Problem

Global SARS-CoV-2 sequencing efforts have resulted in a massive genomic dataset available to the public for a variety of analyses. However, the two most common resources are genome assemblies (e.g. deposited in GISAID and GenBank) and raw sequencing reads. Both of these limit the quantity of information, especially with respect to variants found within the SARS-CoV-2 populations. Genome assemblies only contain consensus level information, which is not reflective of the full genomic diversity within a given sample (since even a single patient derived sample represents a viral population within the host). Raw sequencing reads on the other hand require further analyses in order to extract variant information, and can often be prohibitively large in size. 

Thus, we propose **cov2db**; a database resource for collecting low frequency variant information for available SARS-CoV-2 data (as of October 12th, 2021 there are more than 1.2 million SARS-CoV-2 sequencing datasets in SRA and ENA). Our goal is to provide an easy to use query system, and contribute to a database of VCF files that contain variant calls for SARS-CoV-2 samples. We hope that such interactive database will speed up downstream analyses and encourage collaboration.

![figure6_covid](https://user-images.githubusercontent.com/9452819/137174148-a5a5cff4-4903-4eef-9d46-7e66ed921235.jpeg)
An illustration of low frequency single nucleotide variants (iSNVs) within two viral populations inside infected hosts [DOI:10.1101/gr.268961.120](https://genome.cshlp.org/content/early/2021/02/18/gr.268961.120).

## Timeline

### Sunday:

<img src="ZomboMeme 11102021113553.jpg" width="250">


### During Hackathon
- [x] Annotated 2,000 VCFs
- [x] Converted 2,000 VCFs to JSON
- [x] Scaled up our database to handle the data
- [x] Prototyped a R Shiny UI for database interactions

### Wednesday:

<img src="ZomboMeme 12102021123250.jpg" width="250">



## Features
**cov2db** is a unified database containing information about SARS-CoV-2 strains variants that’s easily available and searchable for the scientific community. Cov2db is hosted in a mongoDB server, but can also be accessed using our Graphical User interface, created with a Shiny R. Our pipeline also provides the tools for any user to include their own datasets to the database, generating a formidable resource for the study of SARS-CoV-2.

Supported queries based on the following fields.

*Annotation:*
- [x] Reference amino acid
- [x] Variant amino acid
- [x] Gene name
- [x] Mutation type (missense, synonymous, upstream, etc.)

*Variant call information:*
- [x] Position
- [x] Allele frequency
- [x] Reference allele
- [x] Alternative allele
- [x] Coverage depth
- [x] Strand bias

*Sample metadata:* 
- [x] Sequencing device
- [x] Library layout
- [x] Submission date
- [x] Study accession 
- [ ] Variant caller

### R Shiny UI
Follow the link below for a quick video demo (no sound) of the R Shiny interface to **cov2db**.
[![R Shiny Demo](https://user-images.githubusercontent.com/9452819/137140289-9c82fae4-fbff-4049-8022-75a42068c6b9.png)](https://youtu.be/dX4oLI-AjhQ "cov2db R Shiny Demo")

### Accessing the database

In order to access the database and run custom queries you will first need to install [MongoDB Compass](https://www.mongodb.com/try/download/compass) or [MongoDB Shell](https://www.mongodb.com/try/download/shell). The following examples make use of MongoDB Compass installation.  

To **connect** to the cov2db database you will need to open MongoDB Compass app and press `⌘N` on a Mac computer or navigate to the menu at the top and pick `Connect`->`Connect to` item.

<img width="579" alt="Screen Shot 2021-10-13 at 10 35 20 AM" src="https://user-images.githubusercontent.com/9452819/137166251-8c08b8be-dc2f-469d-b596-dfc1db06bd52.png">

In the new window paste in the following connection string `mongodb://sno.cs.rice.edu:27017` as shown and click connect.

<img width="1283" alt="Screen Shot 2021-10-13 at 10 37 08 AM" src="https://user-images.githubusercontent.com/9452819/137166544-ab6b79f6-9d24-4af5-a303-5c4a6041f5b0.png">

Finally, select **cov2db** database, and navigate to the `annotated_vcf` collection.

To begin using the shell and start issuing queries, click on the `mongosh` button in the lower left corner and a shell with `>test` prompt will appear.

<img width="330" alt="Screen Shot 2021-10-13 at 10 39 36 AM" src="https://user-images.githubusercontent.com/9452819/137167188-8e5961d6-f1e6-4c2e-95cd-59d4daf6ab18.png">

Finally, type the following command on the shell `use cov2db` to connect to the **cov2db** database.

<img width="347" alt="Screen Shot 2021-10-13 at 10 42 37 AM" src="https://user-images.githubusercontent.com/9452819/137167551-05cb261d-6274-42b7-a854-8e05b6f70437.png">

Now, you are ready to run the queries.

### Example queries 

1. Get the count of missense variants reported for ORF1ab

`db.annotated_vcf.count( { info_SequenceOntology: "missense_variant", info_GeneName: "ORF1ab" } )`
<img width="789" alt="Screen Shot 2021-10-13 at 9 22 34 AM" src="https://user-images.githubusercontent.com/9452819/137153799-b284ae37-1165-454e-958f-c5adcc9515e3.png">

2. Get sample accession numbers for samples that have a variant at position 23403 in the genome

`db.annotated_vcf.find( { start: 23403 }, {VCF_SAMPLE: 1, _id: 0})`
<img width="553" alt="Screen Shot 2021-10-13 at 9 39 52 AM" src="https://user-images.githubusercontent.com/9452819/137155894-8048672d-09a7-4ec3-807d-87689609ef2a.png">

3. Get the count of missense variants occuring at frequency below 1% within the samples with depth of coverage >100000x at the variant call position

`db.annotated_vcf.count( { info_SequenceOntology: "missense_variant", info_af: { $lt: 0.01 }, info_dp: { $gt: 100000} } )`
<img width="974" alt="Screen Shot 2021-10-13 at 11 05 52 AM" src="https://user-images.githubusercontent.com/9452819/137171450-f2b96a31-11ac-407b-ba67-e03139b1708f.png">

4. Get sample accession numbers for samples that is missense variant in gene ORF1ab with allele frequency less than 0.001

`db.annotated_vcf.find( { info_SequenceOntology: "missense_variant", info_GeneName: "ORF1ab", info_af:  { $lt: 0.001 }},{VCF_SAMPLE:1, _id:0} )`
<img width="974" alt="Screenshot" src="https://user-images.githubusercontent.com/11878969/137173163-a745c8db-8635-4eaf-88bc-3cd6812bc528.png">


## Methods

### How to handle iVar data
TSV iVar output was converted to VCF by using the script from [here](https://github.com/nf-core/viralrecon/blob/dev/bin/ivar_variants_to_vcf.py). <br> 
```
python ivar_variants_to_vcf.py example.tsv example.vcf
```

### VCF annotation
The VCF output was then annonated with snpEff.
  **To install snpEff** <br>
  ```
  wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip
  unzip snpEff_latest_core.zip
  ```
  
  **To annotate** <br> 
  ```
  java -Xmx8g -jar ../path/to/snpEff/snpEff.jar NC_045512.2 your_input.vcf > output.ann.vcf
  ```

### annotated VCF to JSON conversion. <br>


### Workflow figure✍️
![covid_freq-Group6 (3)](https://user-images.githubusercontent.com/72709799/137154926-f86e7124-96e8-4d44-8d37-bf3ab3b46b03.jpeg)


## Related work
[VAPr](https://github.com/ucsd-ccbb/VAPr/) is an excellent mongodb based database for storing variant info. UCSC SARS-CoV-2 genome broswers also provides visualization of intrahost variants [here](https://genome.ucsc.edu/cgi-bin/hgTracks?db=wuhCor1&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=NC_045512v2%3A1%2D29903&hgsid=1183075721_4GlEuE8o51gGamZyAQfT5UgwpPhq). 

-----

## Team members
* [Daniel Agustinho](https://github.com/DanielPAagustinho), Washington University <strong>(data acquisition, writer)</strong> <br>
* [Li Chuin Chong](https://github.com/ChongLC), Twincore GmbH/HZI-DKFZ under auspices MHH <strong>(Sysadmin, mongodb)</strong> <br>
* [Maria Jose](https://github.com/MariaJose501), Pondicherry Central University <strong>(data acquisition, mongodb)</strong> <br>
* BaiWei Lo, University of Konstanz <strong>(data acquisition, QC)</strong> <br>
* [Ramanandan Prabhakaran](https://github.com/Ramanandan), Roche Canada <strong>(Sysadmin, python wrapper, mongodb database development, workflow development)</strong> <br>
* [Sophie Poon](https://github.com/chilampoon), <strong>(Data acquisition, QC)</strong> <br>
* [Suresh Kumar](https://github.com/suresh2014), ICAR-NIVEDI <strong>(QC)</strong> <br>
* [Nick Sapoval](https://github.com/nsapoval), Rice University <strong>(Team co-lead, data acquisition, writer, R Shiny development)</strong> <br>
* [Todd Treangen](https://github.com/treangen), <strong>(Team Lead)</strong> <br>


<!--- <img src="ZomboMeme 11102021113553.jpg" width="500">

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
* filter intrahost variants by pvalue, min coverage, variant caller, etc  --->

