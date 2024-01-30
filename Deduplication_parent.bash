#!/bin/sh -l

#SBATCH --job-name Dedup_WGS
#SBATCH -A meixiazhao
#SBATCH --mem=24G
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=2 
#SBATCH --time=4-0:00
#SBATCH -o /blue/meixiazhao/lee.gwonjin/Maize_GBS/scripts/outtext/Dedup_WGS.out
#SBATCH -e /blue/meixiazhao/lee.gwonjin/Maize_GBS/scripts/outtext/Dedup_WGS.err
#SBATCH --mail-type=all          
#SBATCH --mail-user=lee.gwonjin@ufl.edu

module load samtools
module load picard

#working space
cd /blue/meixiazhao/lee.gwonjin/Maize_GBS/WGS/mapping/dedup_bam/B97_undedup


# Deduplication
TMP_DIR=/blue/meixiazhao/lee.gwonjin/Maize_GBS/WGS/mapping/dedup_bam/B97_undedup

coverage_dir="coverage"

# Create the coverage directory if it doesn't exist
mkdir -p "$coverage_dir"

for file in *.sorted.bam; do
    base=$(basename "$file" .sorted.bam)
    output="${base}_dedup.sorted.bam"
    metrics="${base}_dedup.txt"

    # Run picard MarkDuplicates
    picard MarkDuplicates \
        I="$file" \
        REMOVE_DUPLICATES=true \
        CREATE_INDEX=true \
        TMP_DIR="$TMP_DIR" \
        O="$output" \
        M="$metrics"

    # Run samtools coverage with specific options
    samtools coverage "$output" -l 40 -o "$coverage_dir/${base}.coverage.txt"
done

