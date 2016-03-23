#!/bin/bash

# the ../ is a shortcut for specifying the directory above the current working directory
# an alternative way of writing ../ would be to write the full path, in this instance:
# ~/pelotas_2015/whole_genome/ is being substitute by ../

# The data directory and the work directory are imported from the ../config file using this line of code. They are stored in the variables ${datadir} and ${workdir}

source ../config




# This script calculates the genetic relationship matrix for a single chromosome
# This involves calculating how similar each pair of individuals is across all SNPs on that chromosome
# The result is an n x n matrix in binary format


# Set chromosome here

CHR=""

# Probably takes about 5 minutes to run

# --bfile         Location of genotype data
# --make-grm-bin  Calculate GRM
# --maf           Don't use SNPs below this MAF for calculating GRM
# --chr           Which chromosome to analyse
# --out           Where to save output
# --thread-num    Number of CPU threads to parallelise


plink \
	--bfile ${datadir}/geno_qc \
	--make-grm-bin \
	--maf 0.01 \
	--chr ${CHR} \
	--out ../data/geno_qc \
	--thread-num 4


