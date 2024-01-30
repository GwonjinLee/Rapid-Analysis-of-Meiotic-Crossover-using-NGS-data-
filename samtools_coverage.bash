#!/bin/sh -l

#SBATCH --job-name sam_cover
#SBATCH --qos meixiazhao-b
#SBATCH --mem=24G
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=2 
#SBATCH --time=3-0:00
#SBATCH -o /blue/meixiazhao/lee.gwonjin/Maize_GBS/scripts/outtext/sam_cover_CML228.out
#SBATCH -e /blue/meixiazhao/lee.gwonjin/Maize_GBS/scripts/outtext/sam_cover_CML228.err
#SBATCH --mail-type=end          
#SBATCH --mail-user=lee.gwonjin@ufl.edu


module load samtools

#working space
cd /blue/meixiazhao/lee.gwonjin/Maize_GBS/fast-gbs_v2/data/CML228/bam

mkdir coverage

for infile in *.bam
do	base=$(basename ${infile} .bam) 
	
	samtools coverage ${infile} -l 40 -o coverage/${base}.coverage.txt
	
	done

# Merge output

cd /blue/meixiazhao/lee.gwonjin/Maize_GBS/fast-gbs_v2/data/CML228/bam/coverage

for i in *.txt; do
    sed -n '2,11p' < $i >> $i.chr10.txt
done

head -n 1 C228F_A01.coverage.txt > CML228_CovMerg.txt;
	cat *.chr10.txt >> CML228_CovMerg.txt

rm *.chr10.txt
