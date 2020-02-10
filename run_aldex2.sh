#!/bin/bash
rooted_tree=$1
i_table=$2
p_sampling_depth=$3
metadata=$4
dir=$5
column=$6
taxonomy=$7

#ALDeX2

prefix=${i_table%.qza}

mkdir "$dir"/aldex2-"$column"
qiime taxa collapse   --i-table "$i_table"  --i-taxonomy "$taxonomy"   --p-level 2 --o-collapsed-table "$dir"/aldex2-"$column"/"$prefix"-l2.qza
qiime taxa collapse   --i-table "$i_table"  --i-taxonomy "$taxonomy"   --p-level 5 --o-collapsed-table "$dir"/aldex2-"$column"/"$prefix"-l5.qza
qiime taxa collapse   --i-table "$i_table"  --i-taxonomy "$taxonomy"   --p-level 6 --o-collapsed-table "$dir"/aldex2-"$column"/"$prefix"-l6.qza

qiime aldex2 aldex2 --i-table "$i_table" --m-metadata-file "$metadata" --m-metadata-column "$column" --o-differentials "$dir"/aldex2-"$column"/differentials_"$prefix".qza 
qiime aldex2 effect-plot --i-table "$dir"/aldex2-"$column"/differentials_"$prefix".qza --p-threshold 0.05 --o-visualization "$dir"/aldex2-"$column"/aldex2_"$prefix".qzv
qiime aldex2 extract-differences --i-table "$dir"/aldex2-"$column"/differentials_"$prefix".qza --o-differentials "$dir"/aldex2-"$column"/sig-features_"$prefix" \
--p-sig-threshold 1 \
--p-effect-threshold 1 \
--p-difference-threshold 0 2>>errors.txt
qiime tools export --input-path "$dir"/aldex2-"$column"/sig-features_"$prefix".qza --output-path "$dir"/aldex2-"$column" 2>>errors.txt
mv "$dir"/aldex2-"$column"/differentials.tsv "$dir"/aldex2-"$column"/aldex2_"$prefix".tsv 2>>errors.txt


qiime aldex2 aldex2 --i-table "$dir"/aldex2-"$column"/"$prefix"-l2.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-differentials "$dir"/aldex2-"$column"/differentials_"$prefix"-l2.qza
qiime aldex2 effect-plot --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l2.qza --p-threshold 0.05 --o-visualization "$dir"/aldex2-"$column"/aldex2_"$prefix"-l2.qzv
qiime aldex2 extract-differences --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l2.qza --o-differentials "$dir"/aldex2-"$column"/sig-features_"$prefix"-l2 \
--p-sig-threshold 1 \
--p-effect-threshold 1 \
--p-difference-threshold 0 2>>errors.txt
qiime tools export --input-path "$dir"/aldex2-"$column"/sig-features_"$prefix"-l2.qza --output-path "$dir"/aldex2-"$column" 2>>errors.txt
mv "$dir"/aldex2-"$column"/differentials.tsv "$dir"/aldex2-"$column"/aldex2_"$prefix"-l2.tsv 2>>errors.txt

qiime aldex2 aldex2 --i-table "$dir"/aldex2-"$column"/"$prefix"-l5.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-differentials "$dir"/aldex2-"$column"/differentials_"$prefix"-l5.qza
qiime aldex2 effect-plot --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l5.qza --p-threshold 0.05 --o-visualization "$dir"/aldex2-"$column"/aldex2_"$prefix"-l5.qzv
qiime aldex2 extract-differences --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l5.qza --o-differentials "$dir"/aldex2-"$column"/sig-features_"$prefix"-l5 \
--p-sig-threshold 1 \
--p-effect-threshold 1 \
--p-difference-threshold 0 2>>errors.txt
qiime tools export --input-path "$dir"/aldex2-"$column"/sig-features_"$prefix"-l5.qza --output-path "$dir"/aldex2-"$column" 2>>errors.txt
mv "$dir"/aldex2-"$column"/differentials.tsv "$dir"/aldex2-"$column"/aldex2_"$prefix"-l5.tsv 2>>errors.txt

qiime aldex2 aldex2 --i-table "$dir"/aldex2-"$column"/"$prefix"-l6.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-differentials "$dir"/aldex2-"$column"/differentials_"$prefix"-l6.qza
qiime aldex2 effect-plot --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l6.qza --p-threshold 0.05 --o-visualization "$dir"/aldex2-"$column"/aldex2_"$prefix"-l6.qzv
qiime aldex2 extract-differences --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l6.qza --o-differentials "$dir"/aldex2-"$column"/sig-features_"$prefix"-l6 \
--p-sig-threshold 1 \
--p-effect-threshold 1 \
--p-difference-threshold 0 2>>errors.txt
qiime tools export --input-path "$dir"/aldex2-"$column"/sig-features_"$prefix"-l6.qza --output-path "$dir"/aldex2-"$column" 2>>errors.txt
mv "$dir"/aldex2-"$column"/differentials.tsv "$dir"/aldex2-"$column"/aldex2_"$prefix"-l6.tsv 2>>errors.txt
