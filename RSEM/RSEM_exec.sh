#!/bin/bash

cp -r /path/to/rsem_reference ./

sample=$1

echo "Processing sample: ${sample}"

cp /path/to/bam_alignment_files/${sample}_Aligned.toTranscriptome.out.bam ./

rsem-calculate-expression --no-bam-output --paired-end --estimate-rspd --num-threads 12 --fragment-length-max 1000 --forward-prob 0.5 --bam ${sample}_Aligned.toTranscriptome.out.bam ./rsem_reference/reference ${sample}_

cp ./*.results /path/to/results_files/

echo "Done with alignment for ${sample}!"
