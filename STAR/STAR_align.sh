#!/bin/bash

cp -r /path/to/index_files ./

sample=$1

echo "Processing sample: ${sample}"

cp /path/to/fastq_files/${sample}_1.fq.gz ./
cp /path/to/fastq_files/${sample}_2.fq.gz ./

STAR \
 --runMode alignReads \
 --runThreadN 12 \
 --genomeDir ./index_files/ \
 --readFilesIn ${sample}_1.fq.gz ${sample}_2.fq.gz \
 --readFilesCommand gunzip -c \
 --outFileNamePrefix ./${sample}_ \
 --outFilterMultimapNmax 20 \
 --alignSJoverhangMin 8 \
 --alignSJDBoverhangMin 1 \
 --outFilterMismatchNmax 999 \
 --outFilterMismatchNoverLmax 0.1 \
 --alignIntronMin 20 \
 --alignIntronMax 1000000 \
 --alignMatesGapMax 1000000 \
 --outFilterType BySJout \
 --outFilterScoreMinOverLread 0.33 \
 --outFilterMatchNminOverLread 0.33 \
 --limitSjdbInsertNsj 1200000 \
 --outSAMstrandField intronMotif \
 --alignSoftClipAtReferenceEnds Yes \
 --quantMode TranscriptomeSAM GeneCounts \
 --outSAMtype BAM SortedByCoordinate \
 --outSAMunmapped Within \
 --outSAMattrRGline ID:rg1 SM:sm1 \
 --outSAMattributes NH HI AS nM NM ch \
 --chimSegmentMin 15 \
 --chimJunctionOverhangMin 15 \
 --chimOutType WithinBAM SoftClip \
 --chimMainSegmentMultNmax 1 \
 --genomeLoad NoSharedMemory \
 --twopassMode None \
 --readMapNumber -1

cp ./*.bam /path/to/bam_alignment_files/
cp ./*.tab /path/to/tab_output_files/

echo "Done with alignment for ${sample}!"
