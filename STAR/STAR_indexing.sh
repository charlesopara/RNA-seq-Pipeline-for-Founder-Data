#!/bin/bash

sample=$1

echo "Processing sample: ${sample}"

cp /staging/copara/gtf/${sample}.gtf.gz ./
cp /staging/copara/fasta_files/${sample}.fa.gz ./

gunzip *.gz
mkdir ./${sample}_index_files

STAR \
 --runThreadN 24 \
 --runMode genomeGenerate \
 --genomeDir ./${sample}_index_files/ \
 --genomeFastaFiles ./${sample}.fa \
 --sjdbGTFfile ./${sample}.gtf \
 --sjdbOverhang 149

cp -r ./${sample}_index_files /staging/copara/index_files/
