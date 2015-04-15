Whole genome methods practical
==============================

This practical shows you how to perform various whole genome analyses using GCTA on plink format data. It will be run on a linux server. All the scripts are available for you to download here:

[https://github.com/explodecomputer/WholeGenomesPractical](https://github.com/explodecomputer/WholeGenomesPractical)


## Background

The use of very simple, single SNP approaches have actually been very successful in genetic studies. However, with the introduction of whole genome methods the scope of what we might be able to learn from genetic data has broadened significantly. Here we'll look at some of the fundamentals.

The purpose of GWAS is to identify particular SNPs that we are certain have an influence on a trait. In contrast, the purpose of a GCTA style 'GREML' (Genetic REML) or 'SNP heritability' analysis is to estimate how much of the variance of the phenotype can be explained by all the measured SNPs in our data.

The SNP heritability is estimated using a two step procedure. First a genetic covariance matrix, or genetic relationship matrix (GRM) is estimated. This is an *n* x *n* matrix where each element represents the genetic similarity of two individuals. The second step performs REML analysis to essentially estimate how much of the phenotypic covariance in the population is attributable to genetic covariance. 


## A note about software

The original implementation for large scale human data is [GCTA](http://www.complextraitgenomics.com/software/gcta/). It is continually improving, and it has a huge number of features. We will use this to perform REML estimation of heritabilities. It also constructs genetic relationship matrices, which is something that we need, but we will use [Plink2](https://www.cog-genomics.org/plink2/) to do this, as it does the same implementation but much faster.


## Data

We have body mass index (BMI), C-reactive protein (CRP) levels, and hypertension case control status data on each of around 8000 individuals. This is located in `data/phen.txt` We also have covariates, including the first 10 genetic principal components, age, sex, and smoking status (`data/covs.txt`).

To see how this data was QC'd, take a look at the `scripts/qc_phen.R` script. The figures generated from this script are in the `images/` folder.

We also have SNP genotypes for these individuals. Approx 500,000 markers on 23 chromosomes. 

**Note: All the scripts and phenotype data used for this practical are in this repository. The genotype data can be made available upon request - just ask!**

## Using SNPs to estimate kinship

How far removed must two individuals be from one another before they are considered 'unrelated'? We can make estimates of the proportion of the genome that is shared identical by descent (IBD) between all pairs of seemingly unrelated individuals from the population by calculating the proportion of SNPs that are identical by state (IBS). 

The result is a genetic relationship matrix (GRM, aka kinship matrix) of size *n* x *n*, diagonals are estimates of an individual's inbreeding and off-diagonals are an estimate of genomic similarity for pairs of individuals.


## Using kinships to estimate heritability

See slides for more accurate treatment, but the intuition is as follows. Heritability is the measure of the proportion of variation that is due to genetic variation. If individuals who are more phenotypically similar also tend to be more genetically similar then this is evidence that heritability is non-zero. We can make estimates of heritability by comparing these similarities.

When genetic similarity is calculated by using SNPs then we are no longer estimating heritability per se, we are instead estimating how much of the phenotypic variance can be explained by all the SNPs in our model.



## Exercises

0.	First we need to setup the scripts to run on our server. First clone the repository:
		
		git clone git@github.com:explodecomputer/WholeGenomesPractical.git

	This will take a few moments to download. Next, setup the `config` file to point the scripts to their location on the server and the location of the `geno_qc` files, e.g. using the `nano` programme to edit the file:
	
		nano WholeGenomesPractical/config
	
	Finally, put the `plink1.90` and `gcta64` binaries in the `~/bin` folder in your home directory:

		mkdir -p ~/bin
		cp WholeGenomesPractical/bin/* ~/bin

	You should now be able to execute these two programmes by simply running:

		gcta64
		plink1.90


1.	Scrutinise the data. Checking for:
	- Clean genotype data
	- Normally distributed phenotypes with no outliers
	- Presence of covariates including principal components

2. 	Construct the genetic relationship matrix using the QC'd SNPs:

        cd WholeGenomesPractical/scripts
        ./construct_grm.sh


3. 	We have now calculated a genetic relationship value for every pair of individuals. If the sample comprises only 'unrelated' individuals then each pair of individuals should have a genetic relationship less than 0.05 (and a relationship with themselves of approximately 1). Use the `analyse_grm.R` script to read in the GRM files into R and plot the distribution of relationships:

		R --no-save < analyse_grm.R

	Why is it important to make sure that related individuals are not included in this analysis?

4. 	Calculate SNP heritabilities with and without covariates. What are the SNP heritabilities for each of the traits and how do the estimates differ when covariates are not included? Use the commands in `estimate_heritability.sh` to do this.

5. Recalculate the SNP heritability for hypertension but this time on the liability scale.

6. 	In addition to estimating the SNP heritability of each trait, we can calculate how similar the genetic effects are for a pair of traits. This is also known as the genetic correlation. Perform bivariate GREML analysis to calculate genetic correlations between each pair of traits. Use the commands in `estimate_bivariate.sh` to do this.

7.	Under the infinitesimal model we assume that every SNP has an effect and each effect is small. One way we can test this would be to see if larger chromosomes explain more of the variance than smaller chromosomes. We can do this in GCTA by partitioning the genome into 22 chromosomes, and estimating the variance explained by all the SNPs on each chromosome. To do this first make a GRM for each of the 22 chromosomes:

		./construct_grm_chr.sh

	This script creates the 22 GRMs, plus a text file called `geno_qc_chr.mgrm` which lists the locations of each of the GRMs. Now we can estimate the variance attributed to each chromosome:

		./estimate_partition.sh

	Visualise the results by using the `plot_partition.R` script.

8. 	Construct two GRMs, one using chromosomes 1-8 and another using 9-22. Estimate the heritability of each GRM separately and both combined. Do this with and without covariates included. Is the sum of heritabilities for each chromosome the same as that for the entire genome? Use the commands in `estimate_confounding.sh` to do this.
