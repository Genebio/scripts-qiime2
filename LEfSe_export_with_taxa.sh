#!/bin/bash
table=$1
taxonomy=$2
outdir=$3
prefix=${table%.qza}

mkdir  -p "$outdir"

qiime taxa collapse   --i-table "$table"  --i-taxonomy "$taxonomy"   --p-level 2 --o-collapsed-table "$outdir"/"$prefix"-level_2.qza
qiime taxa collapse   --i-table "$table"  --i-taxonomy "$taxonomy"   --p-level 6 --o-collapsed-table "$outdir"/"$prefix"-level_6.qza

qiime tools export --input-path "$taxonomy" --output-path "$outdir" 
sed -i "1s/.*/#OTUID\ttaxonomy\tconfidence/" "$outdir"/taxonomy.tsv

qiime tools export --input-path "$table" --output-path "$outdir"
mv "$outdir"/feature-table.biom "$outdir"/"$prefix".biom 

biom add-metadata -i "$outdir"/"$prefix".biom -o "$outdir"/"$prefix".biom --observation-metadata-fp "$outdir"/taxonomy.tsv --sc-separated taxonomy
biom convert --input-fp "$outdir"/"$prefix".biom --output-fp "$outdir"/"$prefix"_with_taxa.tsv --to-tsv --header-key taxonomy

qiime tools export --input-path "$outdir"/"$prefix"-level_2.qza --output-path "$outdir"
mv "$outdir"/feature-table.biom "$outdir"/"$prefix"-level_2.biom
biom add-metadata -i "$outdir"/"$prefix"-level_2.biom -o "$outdir"/"$prefix"-level_2.biom --observation-metadata-fp "$outdir"/taxonomy.tsv --sc-separated taxonomy
biom convert --input-fp "$outdir"/"$prefix"-level_2.biom --output-fp "$outdir"/"$prefix"-level_2_with_taxa.tsv --to-tsv --header-key taxonomy

qiime tools export --input-path "$outdir"/"$prefix"-level_6.qza --output-path "$outdir"
mv "$outdir"/feature-table.biom "$outdir"/"$prefix"-level_6.biom
biom add-metadata -i "$outdir"/"$prefix"-level_6.biom -o "$outdir"/"$prefix"-level_6.biom --observation-metadata-fp "$outdir"/taxonomy.tsv --sc-separated taxonomy
biom convert --input-fp "$outdir"/"$prefix"-level_6.biom --output-fp "$outdir"/"$prefix"-level_6_with_taxa.tsv --to-tsv --header-key taxonomy

#relative abundance table with taxa
qiime feature-table relative-frequency --i-table "$table" --o-relative-frequency-table "$outdir"/"$prefix"_rel_abund.qza
qiime feature-table relative-frequency --i-table "$outdir"/"$prefix"-level_2.qza --o-relative-frequency-table "$outdir"/"$prefix"_rel_abund-level_2.qza
qiime feature-table relative-frequency --i-table "$outdir"/"$prefix"-level_6.qza --o-relative-frequency-table "$outdir"/"$prefix"_rel_abund-level_6.qza


qiime tools export --input-path "$outdir"/"$prefix"_rel_abund.qza --output-path "$outdir"
mv "$outdir"/feature-table.biom "$outdir"/"$prefix"_rel_abund.biom
biom add-metadata -i "$outdir"/"$prefix"_rel_abund.biom -o "$outdir"/"$prefix"_rel_abund.biom --observation-metadata-fp "$outdir"/taxonomy.tsv --sc-separated taxonomy
biom convert --input-fp "$outdir"/"$prefix"_rel_abund.biom --output-fp "$outdir"/"$prefix"_rel_abund_with_taxa.tsv --to-tsv --header-key taxonomy

qiime tools export --input-path "$outdir"/"$prefix"_rel_abund-level_2.qza --output-path "$outdir"
mv "$outdir"/feature-table.biom "$outdir"/"$prefix"_rel_abund-level_2.biom
biom add-metadata -i "$outdir"/"$prefix"_rel_abund-level_2.biom -o "$outdir"/"$prefix"_rel_abund-level_2.biom --observation-metadata-fp "$outdir"/taxonomy.tsv --sc-separated taxonomy
biom convert --input-fp "$outdir"/"$prefix"_rel_abund-level_2.biom --output-fp "$outdir"/"$prefix"_rel_abund-level_2_with_taxa.tsv --to-tsv --header-key taxonomy

qiime tools export --input-path "$outdir"/"$prefix"_rel_abund-level_6.qza --output-path "$outdir"
mv "$outdir"/feature-table.biom "$outdir"/"$prefix"_rel_abund-level_6.biom
biom add-metadata -i "$outdir"/"$prefix"_rel_abund-level_6.biom -o "$outdir"/"$prefix"_rel_abund-level_6.biom --observation-metadata-fp "$outdir"/taxonomy.tsv --sc-separated taxonomy
biom convert --input-fp "$outdir"/"$prefix"_rel_abund-level_6.biom --output-fp "$outdir"/"$prefix"_rel_abund-level_6_with_taxa.tsv --to-tsv --header-key taxonomy

sed -i '1d' "$outdir"/*_with_taxa.tsv
rm -f "$outdir"/*.biom

