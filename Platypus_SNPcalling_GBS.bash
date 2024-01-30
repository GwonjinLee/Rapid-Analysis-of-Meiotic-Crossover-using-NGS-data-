#!/bin/sh -l

#SBATCH --job-name SNPcalling_GBS
#SBATCH --qos meixiazhao-b
#SBATCH --mem=48G
#SBATCH --nodes=4
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=8 
#SBATCH --time=12-0:00
#SBATCH -o /blue/meixiazhao/lee.gwonjin/Maize_GBS/scripts/outtext/SNPcalling_GBS.out
#SBATCH -e /blue/meixiazhao/lee.gwonjin/Maize_GBS/scripts/outtext/SNPcalling_GBS.err
#SBATCH --mail-type=all          
#SBATCH --mail-user=lee.gwonjin@ufl.edu

#Load the modules
module load gcc/5.2.0 #need this version to avoid version crash
module load pyvcf
module load python/2.7.10
module load platypus

#working space
cd /blue/meixiazhao/lee.gwonjin/Maize_GBS/fast-gbs_v2/data


Platypus.py callVariants --bamFiles=../results/List_C228_bam \
--nCPU=6 --minMapQual=20 --minBaseQual=20 --minGoodQualBases=5 --badReadsThreshold=10 \
--rmsmqThreshold=20 --abThreshold=0.01 --maxReadLength=250 --hapScoreThreshold=20 \
--trimAdapter=0 --maxGOF=20 --maxReads=500000000 \
--minReads=4 --genIndels=0 --minFlank=5 \
--sbThreshold=0.01 --scThreshold=0.95 --hapScoreThreshold=15 \
--filterDuplicates=0 \
--filterVarsByCoverage=0 --filteredReadsFrac=0.7 --minVarFreq=0.002 \
--mergeClusteredVariants=0 --filterReadsWithUnmappedMates=0 \
--refFile=/blue/meixiazhao/lee.gwonjin/Maize_GBS/fast-gbs_v2/refgenome/Zm-B73-REFERENCE-NAM-5.0.fa \
--output=CML228.vcf \
--logFileName=CML228_snpcalling_log.txt


module load vcftools
module load bcftools

bcftools stats CML228.vcf > CML228_unfiltered.txt


vcftools --vcf CML228.vcf --remove-filtered-all --max-missing 0.85 \
--remove-indels --min-alleles 2 --max-alleles 2 \
--maf 0.01 --maxDP 3000 --minDP 8 --minQ 40 --minGQ 10 \
--recode --recode-INFO-all \
--out CML228_filtered85

vcftools --vcf CML228.vcf --remove-filtered-all --max-missing 0.60 \
--remove-indels --min-alleles 2 --max-alleles 2 \
--maf 0.01 --maxDP 3000 --minDP 8 --minQ 40 --minGQ 10 \
--recode --recode-INFO-all \
--out CML228_filtered60


bcftools stats CML228_filtered85.recode.vcf > CML228_filtered85.txt
bcftools stats CML228_filtered60.recode.vcf > CML228_filtered60.txt