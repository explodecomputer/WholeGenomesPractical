#!/bin/bash

# the ../ is a shortcut for specifying the directory above the current working directory
# an alternative way of writing ../ would be to write the full path, in this instance:
# ~/pelotas_2015/whole_genome/ is being substitute by ../

# The data directory and the work directory are imported from the ../config file using this line of code. They are stored in the variables ${datadir} and ${workdir}

source ../config


# This script calculates the genetic relationship matrix
# This involves calculating how similar each pair of individuals is across all SNPs in the data
# The result is an n x n matrix in binary format
# 
# Probably takes about 5 minutes to run

# --bfile         Location of genotype data
# --make-grm-bin  Calculate GRM
# --maf           Don't use SNPs below this MAF for calculating GRM
# --out           Where to save output

plink \
	--bfile ${datadir}/geno_qc \
	--make-grm-bin \
	--maf 0.01 \
	--out ../data/geno_qc \
	--thread-num 16

