#!/bin/bash

rep_seqs=$1
i_table=$2
metadata=$3

prefix=${rep_seqs%_rep-seqs-dada2.qza}

#Phylogenetic tree
qiime alignment mafft \
--i-sequences "$rep_seqs" \
--o-alignment "$prefix"_aligned-rep-seqs-dada2.qza

qiime alignment mask \
--i-alignment "$prefix"_aligned-rep-seqs-dada2.qza \
 --o-masked-alignment "$prefix"_masked-aligned-rep-seqs.qza

qiime phylogeny fasttree \
--i-alignment "$prefix"_masked-aligned-rep-seqs.qza \
--o-tree "$prefix"_unrooted-tree.qza

qiime phylogeny midpoint-root \
--i-tree "$prefix"_unrooted-tree.qza \
--o-rooted-tree "$prefix"_tree.qza

#Taxonomy
qiime feature-classifier classify-sklearn \
--i-classifier ../qiime2/gg-13-8-99-515-806-nb-classifier.qza \
--i-reads "$rep_seqs" \
--o-classification "$prefix"_taxonomy.qza


#Taxonomy based filtering sequences
qiime taxa filter-seqs \
--i-sequences "$rep_seqs" \
--i-taxonomy "$prefix"_taxonomy.qza \
--p-include p__ \
--p-exclude mitochondria,chloroplast \
--o-filtered-sequences "$prefix"_clean_rep-seqs-dada2.qza

qiime taxa filter-table \
--i-table "$i_table" \
--i-taxonomy "$prefix"_taxonomy.qza \
--p-include p__ \
--p-exclude mitochondria,chloroplast \
--o-filtered-table "$prefix"_clean_table.qza

qiime feature-table summarize \
--i-table "$prefix"_clean_table.qza \
--o-visualization "$prefix"_clean_table.qzv \
--m-sample-metadata-file "$metadata" 

qiime feature-classifier classify-sklearn \
--i-classifier ../qiime2/gg-13-8-99-515-806-nb-classifier.qza \
--i-reads "$prefix"_clean_rep-seqs-dada2.qza \
--o-classification "$prefix"_taxonomy_clean.qza

qiime metadata tabulate \
--m-input-file "$prefix"_taxonomy_clean.qza \
--o-visualization "$prefix"_taxonomy_clean.qzv