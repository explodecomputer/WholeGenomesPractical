#!/bin/bash

# the ../ is a shortcut for specifying the directory above the current working directory
# an alternative way of writing ../ would be to write the full path, in this instance:
# ~/pelotas_2015/whole_genome/ is being substitute by ../

# The data directory and the work directory are imported from the ../config file using this line of code. They are stored in the variables ${datadir} and ${workdir}

source ../config

# Objective: 
# Split the genome into two halves
# Calculate GRM for first half and second half
# Estimate SNP-h2 for each half and then jointly
# Do this with and without covariates being included


# --bfile         Location of genotype data
# --make-grm-bin  Calculate GRM
# --maf           Don't use SNPs below this MAF for calculating GRM
# --extract       Only use SNPs specified in this file to create GRM
# --out           Where to save output

# --grm           Location of the GRM files
# --mgrm          Location of text file specifying all GRM files to be included
# --reml          Perform REML analysis
# --reml-no-lrt   Don't run the likelihood test at the end of the REML
# --pheno         Location of phenotype file
# --mpheno        Which column in phen file to analyse
# --qcovar        Location of covariates file
# --thread        How many threads to use



# Get SNP IDs from chr1-8
awk '{ if ($1 < 9) print $2}' ${datadir}/geno_qc.bim > ../data/chr1-8.txt

# Create GRM using SNPs only from chr1-8
plink \
	--bfile ${datadir}/geno_qc \
	--make-grm-bin \
	--maf 0.01 \
	--extract ../data/chr1-8.txt \
	--out ../data/geno_1-8

# Create GRM using SNPs only from chr9-22
plink \
	--bfile ${datadir}/geno_qc \
	--make-grm-bin \
	--maf 0.01 \
	--exclude ../data/chr1-8.txt \
	--out ../data/geno_9-22

# Create the MGRM file (contains the filepaths for the two GRMs above)
echo -e "${workdir}/whole_genome/data/geno_1-8\n${workdir}/whole_genome/data/geno_9-22" > ../data/mgrm.txt


# Perform REML using chr1-8 (partition1), chr9-22 (partition2), or both partitions together (partition)
# If there is pop strat influencing the trait then the SNPs will be confounded with common environmental effects
# The common environmental effect will be the same whether chr1-8 are used or chr9-22. 
# Therefore, the sum of estimates of h2 from chr1-8 and chr9-22 will be greater than the estimate from the combined data.
# This can be used as a test to see if pop strat is being accounted for.

# BMI with covariates
gcta \
	--grm ../data/geno_1-8 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 1 \
	--qcovar ../data/covs.txt \
	--out ../results/partition1_bmi_covar \
	--thread-num 8

gcta \
	--grm ../data/geno_9-22 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 1 \
	--qcovar ../data/covs.txt \
	--out ../results/partition2_bmi_covar \
	--thread-num 8

gcta \
	--mgrm ../data/mgrm.txt \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 1 \
	--qcovar ../data/covs.txt \
	--out ../results/partition_bmi_covar \
	--thread-num 8

# BMI without covariates
gcta \
	--grm ../data/geno_1-8 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 1 \
	--out ../results/partition1_bmi_nocovar \
	--thread-num 8

gcta \
	--grm ../data/geno_9-22 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 1 \
	--out ../results/partition2_bmi_nocovar \
	--thread-num 8

gcta \
	--mgrm ../data/mgrm.txt \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 1 \
	--out ../results/partition_bmi_nocovar \
	--thread-num 8


# CRP with covariates
gcta \
	--grm ../data/geno_1-8 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 2 \
	--qcovar ../data/covs.txt \
	--out ../results/partition1_crp_covar \
	--thread-num 8

gcta \
	--grm ../data/geno_9-22 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 2 \
	--qcovar ../data/covs.txt \
	--out ../results/partition2_crp_covar \
	--thread-num 8

gcta \
	--mgrm ../data/mgrm.txt \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 2 \
	--qcovar ../data/covs.txt \
	--out ../results/partition_crp_covar \
	--thread-num 8

# CRP without covariates
gcta \
	--grm ../data/geno_1-8 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 2 \
	--out ../results/partition1_crp_nocovar \
	--thread-num 8

gcta \
	--grm ../data/geno_9-22 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 2 \
	--out ../results/partition2_crp_nocovar \
	--thread-num 8

gcta \
	--mgrm ../data/mgrm.txt \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 2 \
	--out ../results/partition_crp_nocovar \
	--thread-num 8

# Hypertension with covariates
gcta \
	--grm ../data/geno_1-8 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 3 \
	--qcovar ../data/covs.txt \
	--out ../results/partition1_hypertension_covar \
	--thread-num 8

gcta \
	--grm ../data/geno_9-22 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 3 \
	--qcovar ../data/covs.txt \
	--out ../results/partition2_hypertension_covar \
	--thread-num 8

gcta \
	--mgrm ../data/mgrm.txt \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 3 \
	--qcovar ../data/covs.txt \
	--out ../results/partition_hypertension_covar \
	--thread-num 8

# Hypertension without covariates
gcta \
	--grm ../data/geno_1-8 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 3 \
	--out ../results/partition1_hypertension_nocovar \
	--thread-num 8

gcta \
	--grm ../data/geno_9-22 \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 3 \
	--out ../results/partition2_hypertension_nocovar \
	--thread-num 8

gcta \
	--mgrm ../data/mgrm.txt \
	--reml \
	--reml-no-lrt \
	--pheno ../data/phen.txt \
	--mpheno 3 \
	--out ../results/partition_hypertension_nocovar \
	--thread-num 8
