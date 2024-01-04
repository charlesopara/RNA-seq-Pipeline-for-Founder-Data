#!/bin/bash

sample=$1

echo "Processing sample: ${sample}"

cp /path/to/gtf/${sample}.gtf.gz ./
cp /path/to/fasta_files/${sample}.fa.gz ./

gunzip *.gz
mkdir ./${sample}_rsem_reference

rsem-prepare-reference -p 24 --gtf ${sample}.gtf ${sample}.fa ./${sample}_rsem_reference/${sample}_reference

cp -r ./${sample}_rsem_reference /path/to/reference_files/
