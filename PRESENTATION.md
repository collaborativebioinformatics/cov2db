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

### Sunday

<img src="ZomboMeme 11102021113553.jpg" width="250">



### During Hackathon
- [x] Annotated 2,000 VCFs
- [x] Converted 2,000 VCFs to JSON
- [x] Scaled up our database to handle the data
- [x] Prototyped a R Shiny UI for database interactions

### Wednesday
<img src="ZomboMeme 12102021123250.jpg" width="250">



## Methods

### Workflow figure✍️
![covid_freq-Group6 (4)](https://user-images.githubusercontent.com/72709799/137173152-37368b5a-702e-44b5-94f1-31a4c2176a2d.jpeg)


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

5. Aggregate variant call data and metadata

`db.annotated_vcf.aggregate( {$lookup: {from: "coguk_metadata", localField: "VCF_SAMPLE", foreignField: "run_accession", as: "metadata"}} )`
<img width="1116" alt="Screen Shot 2021-10-13 at 11 19 07 AM" src="https://user-images.githubusercontent.com/9452819/137173909-da71291b-1f2c-40f3-a11b-791d3667d0fb.png">

### R Shiny UI
Follow the link below for a quick video demo (no sound) of the R Shiny interface to **cov2db**.
[![R Shiny Demo](https://user-images.githubusercontent.com/9452819/137140289-9c82fae4-fbff-4049-8022-75a42068c6b9.png)](https://youtu.be/dX4oLI-AjhQ "cov2db R Shiny Demo")

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

## Related work
[VAPr](https://github.com/ucsd-ccbb/VAPr/) is an excellent mongodb based database for storing variant info. UCSC SARS-CoV-2 genome broswers also provides visualization of intrahost variants [here](https://genome.ucsc.edu/cgi-bin/hgTracks?db=wuhCor1&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=NC_045512v2%3A1%2D29903&hgsid=1183075721_4GlEuE8o51gGamZyAQfT5UgwpPhq). 

-----

## Team members
* Daniel Agustinho, Washington University <strong>(data acquisition, writer)</strong> <br>
* Li Chuin Chong, Twincore GmbH/HZI-DKFZ under auspices MHH <strong>(Sysadmin, mongodb)</strong> <br>
* Maria Jose, Pondicherry Central University <strong>(data acquisition, mongodb)</strong> <br>
* BaiWei Lo, University of Konstanz <strong>(data acquisition, QC)</strong> <br>
* Ramanandan Prabhakaran, Roche Canada <strong>(Sysadmin, mongodb database development, workflow development)</strong> <br>
* Sophie Poon, <strong>(Data acquisition, QC)</strong> <br>
* Suresh Kumar, ICAR-NIVEDI <strong>(QC)</strong> <br>
* Nick Sapoval, Rice University <strong>(Team co-lead, data acquisition, writer, R Shiny development)</strong> <br>
* Todd Treangen <strong>(Team Lead)</strong> <br>

