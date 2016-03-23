#!/bin/bash

# the ../ is a shortcut for specifying the directory above the current working directory
# an alternative way of writing ../ would be to write the full path, in this instance:
# ~/pelotas_2015/whole_genome/ is being substitute by ../

# The data directory and the work directory are imported from the ../config file using this line of code. They are stored in the variables ${datadir} and ${workdir}

source ../config


# We will calculate the SNP-heritability using GCTA
# It has very similar syntax to PLINK
# We specify the GRM, phenotype data, covariate data and it performs REML


# --mgrm                 Location of the text file that lists all GRM files to include
# --reml                 Perform REML analysis
# --reml-no-lrt          Don't run the likelihood test at the end of the REML
# --reml-no-constrain    Allow estimates to go below 0 or above 1
# --pheno                Location of phenotype file
# --mpheno               Which column in phen file to analyse
# --qcovar               Location of covariates file
# --out                  Where to save output
# --thread               How many threads to use



# BMI
gcta \
	--mgrm ../data/geno_qc_chr.mgrm \
	--reml \
	--reml-no-lrt \
	--reml-no-constrain \
	--pheno ../data/phen.txt \
	--mpheno 1 \
	--qcovar ../data/covs.txt \
	--out ../results/bmi_partition \
	--thread-num 16

# CRP
gcta \
	--mgrm ../data/geno_qc_chr.mgrm \
	--reml \
	--reml-no-lrt \
	--reml-no-constrain \
	--pheno ../data/phen.txt \
	--mpheno 2 \
	--qcovar ../data/covs.txt \
	--out ../results/crp_partition \
	--thread-num 16

# Hypertension
gcta \
	--mgrm ../data/geno_qc_chr.mgrm \
	--reml \
	--reml-no-lrt \
	--reml-no-constrain \
	--pheno ../data/phen.txt \
	--mpheno 3 \
	--qcovar ../data/covs.txt \
	--out ../results/hypertension_partition \
	--prevalence 0.30 \
	--thread-num 16
