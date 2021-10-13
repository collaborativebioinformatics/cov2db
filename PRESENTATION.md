
![Visitor](https://visitor-badge.laobi.icu/badge?page_id=https://github.com/collaborativebioinformatics/cov2db)
# cov2db: a low frequency variant DB for SARS-CoV-2

![cov2db_logo_bg](https://user-images.githubusercontent.com/9452819/137010749-a6bebcbd-ddb6-4b0b-900e-a85fe9125c59.png)
(SARS-CoV-2 Illustration image credit: Davian Ho for the [Innovative Genomics Institute](https://innovativegenomics.org/free-covid-19-illustrations/))

-----

## Problem

Global SARS-CoV-2 sequencing efforts have resulted in a massive genomic dataset available to the public for a variety of analyses. However, the two most common resources are genome assemblies (e.g. deposited in GISAID and GenBank) and raw sequencing reads. Both of these limit the quantity of information, especially with respect to variants found within the SARS-CoV-2 populations. Genome assemblies only contain consensus level information, which is not reflective of the full genomic diversity within a given sample (since even a single patient derived sample represents a viral population within the host). Raw sequencing reads on the other hand require further analyses in order to extract variant information, and can often be prohibitively large in size. 

Thus, we propose **cov2db**; a database resource for collecting low frequency variant information for available SARS-CoV-2 data (currently there are more than 1.2 million SARS-CoV-2 sequencing datasets in SRA and ENA). Our goal is to provide an easy to use query system, and contribute to a database of VCF files that contain variant calls for SARS-CoV-2 samples. We hope that such interactive database will speed up downstream analyses and encourage collaboration.

<!--- VCF files storing low frequency info for SARS-CoV-2 are not widely available due to their size and limited downstream usage to date. However, there are over 1.2 million sequenced datasets in ENA/SRA from COVID-19 samples, representing a unique opportunity to create a community resource for query and tracking intrahost viral evolution. The goal of this hackathon project is to create an easy to use database for the community that is able to store SARS-CoV-2 low frequency/intrahost variants. --->

## Timeline

Sunday:

<img src="ZomboMeme 11102021113553.jpg" width="250">

Wednesday:

<img src="ZomboMeme 12102021123250.jpg" width="250">

- [x] Annotated 2,000 VCFs
- [x] Converted 2,000 VCFs to JSON
- [x] Scaled up our database to handle the data
- [x] Prototyped a R Shiny UI for database interactions

## Features
**cov2db** is a tool that allows for integration of available variant calls from SARS-CoV-2 strains into an unified database. This makes this information easily available and searchable for the scientific community. This workflow  accepts a variety of versions of variant call files (VCF)as input. Our pipeline will annotate variants, convert the files to JSON and input the information to the MongoDB database. Once in the database, information about variants are easily queryable using a graphical user interface in Shiny.

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

*Sample metadata:* [in development]
- [ ] Sequencing device
- [ ] Library layout
- [ ] Submission date
- [ ] Study accession 
- [ ] Variant caller

### R Shiny UI
Follow the link below for a quick video demo of the R Shiny interface to **cov2db**.
[![R Shiny Demo](https://user-images.githubusercontent.com/9452819/137140289-9c82fae4-fbff-4049-8022-75a42068c6b9.png)](https://youtu.be/dX4oLI-AjhQ "cov2db R Shiny Demo")

### Example queries 

1. Get the count of missense variants reported for ORF1ab

`db.annotated_vcf.count( { info_SequenceOntology: "missense_variant", info_GeneName: "ORF1ab" } )`
<img width="789" alt="Screen Shot 2021-10-13 at 9 22 34 AM" src="https://user-images.githubusercontent.com/9452819/137153799-b284ae37-1165-454e-958f-c5adcc9515e3.png">

2. Get sample accession numbers for samples that have a variant at position 23403 in the genome (D614G)

`db.annotated_vcf.find( { start: 23403 }, {VCF_SAMPLE: 1, _id: 0})`
<img width="553" alt="Screen Shot 2021-10-13 at 9 39 52 AM" src="https://user-images.githubusercontent.com/9452819/137155894-8048672d-09a7-4ec3-807d-87689609ef2a.png">

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
* Daniel Agustinho, Washington University (data acquisition, writer) <br>
* Li Chuin Chong, Twincore GmbH/HZI-DKFZ under auspices MHH (Sysadmin, mongodb) <br>
* Maria Jose, Pondicherry Central University (data acquisition, mongodb)
* BaiWei Lo, University of Konstanz (data acquisition, QC) <br>
* Ramanandan Prabhakaran, Roche Canada (Sysadmin, mongodb database development, workflow development) <br>
* Sophie Poon, (Data acquisition, QC)<br>
* Suresh Kumar, ICAR-NIVEDI (QC)<br>
* Nick Sapoval, Rice University (Team co-lead, data acquisition, writer) <br>
* Todd Treangen (Team Lead) <br>
