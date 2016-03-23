#!/bin/bash

# the ../ is a shortcut for specifying the directory above the current working directory
# an alternative way of writing ../ would be to write the full path, in this instance:
# ~/pelotas_2015/whole_genome/ is being substitute by ../

# The data directory and the work directory are imported from the ../config file using this line of code. They are stored in the variables ${datadir} and ${workdir}

source ../config


# Bivariate analysis - calculate the genetic correlation between two traits
# Each one takes about 20 minutes with 8 cores

# --grm           Location of the GRM files
# --reml-bivar    Perform bivariate REML analysis on the specified columns in
#                 phen file
# --pheno         Location of phenotype file
# --qcovar        Location of covariates file
# --out           Where to save output
# --thread        How many threads to use


# NOTE
# This analysis is being performed on pre-computed GRMs that are stored in the central data directory 
# (see the ../config file for its location)


# BMI vs CRP
gcta \
	--grm ${datadir}/geno_qc \
	--reml-bivar 1 2 \
	--pheno ../data/phen.txt \
	--qcovar ../data/covs.txt \
	--out ../results/bivariate_bmi_crp \
	--thread-num 4

# BMI vs hypertension
gcta \
	--grm ${datadir}/geno_qc \
	--reml-bivar 1 3 \
	--pheno ../data/phen.txt \
	--qcovar ../data/covs.txt \
	--out ../results/bivariate_bmi_hypertension \
	--thread-num 4

# CRP vs hypertension
gcta \
	--grm ${datadir}/geno_qc \
	--reml-bivar 2 3 \
	--pheno ../data/phen.txt \
	--qcovar ../data/covs.txt \
	--out ../results/bivariate_crp_hypertension \
	--thread-num 4
