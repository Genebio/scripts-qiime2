#!/bin/bash
rooted_tree=$1
i_table=$2
p_sampling_depth=$3
metadata=$4
dir=$5
column=$6
taxonomy=$7

#core-metrics
qiime diversity core-metrics-phylogenetic \
--i-phylogeny "$rooted_tree" \
--i-table "$i_table" \
--p-sampling-depth "$p_sampling_depth" \
--m-metadata-file "$metadata" \
--output-dir "$dir"

#weighted_normalized_unifrac
qiime diversity beta-phylogenetic --i-table "$i_table" --i-phylogeny "$rooted_tree" --p-metric weighted_normalized_unifrac --o-distance-matrix "$dir"/weighted_normalized_unifrac_distance_matrix.qza
qiime diversity pcoa --i-distance-matrix "$dir"/weighted_normalized_unifrac_distance_matrix.qza --o-pcoa "$dir"/weighted_normalized_unifrac_pcoa_results.qza
qiime emperor plot --i-pcoa "$dir"/weighted_normalized_unifrac_pcoa_results.qza --m-metadata-file "$metadata" --o-visualization "$dir"/weighted_normalized_unifrac_emperor.qzv


#Alpha-diversity
qiime diversity alpha-group-significance --i-alpha-diversity  "$dir"/faith_pd_vector.qza  --m-metadata-file "$metadata" --o-visualization "$dir"/faith_pd_statistics.qzv 
qiime diversity alpha-group-significance --i-alpha-diversity  "$dir"/shannon_vector.qza  --m-metadata-file "$metadata" --o-visualization "$dir"/shannon_statistics.qzv 

#Beta-diversity
qiime diversity beta-group-significance --i-distance-matrix "$dir"/unweighted_unifrac_distance_matrix.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-visualization "$dir"/unweighted_unifrac-"$column"-significance.qzv
qiime diversity beta-group-significance --i-distance-matrix "$dir"/weighted_unifrac_distance_matrix.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-visualization "$dir"/weighted_unifrac-"$column"-significance.qzv
qiime diversity beta-group-significance --i-distance-matrix "$dir"/weighted_normalized_unifrac_distance_matrix.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-visualization "$dir"/weighted_normalized_unifrac-"$column"-significance.qzv
qiime diversity beta-group-significance --i-distance-matrix "$dir"/bray_curtis_distance_matrix.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-visualization "$dir"/bray_curtis-"$column"-significance.qzv


#ANCOM
prefix=${i_table%.qza}

qiime composition add-pseudocount   --i-table "$i_table" --output-dir "$dir"/ancom-"$column" --o-composition-table "$dir"/ancom-"$column"/"$prefix"_comp.qza
qiime composition ancom --i-table  "$dir"/ancom-"$column"/"$prefix"_comp.qza  --m-metadata-file "$metadata"  --m-metadata-column "$column" --o-visualization  "$dir"/ancom-"$column"/"$prefix"-ancom-"$column".qzv

qiime taxa collapse   --i-table "$i_table"  --i-taxonomy "$taxonomy"   --p-level 2 --o-collapsed-table "$dir"/ancom-"$column"/"$prefix"-l2.qza
qiime composition add-pseudocount   --i-table  "$dir"/ancom-"$column"/"$prefix"-l2.qza --o-composition-table "$dir"/ancom-"$column"/"$prefix"-comp-l2.qza
qiime composition ancom --i-table  "$dir"/ancom-"$column"/"$prefix"-comp-l2.qza  --m-metadata-file "$metadata"  --m-metadata-column "$column" --o-visualization  "$dir"/ancom-"$column"/"$prefix"-level_2-ancom-"$column".qzv

qiime taxa collapse   --i-table "$i_table"  --i-taxonomy "$taxonomy"   --p-level 5 --o-collapsed-table "$dir"/ancom-"$column"/"$prefix"-l5.qza
qiime composition add-pseudocount   --i-table  "$dir"/ancom-"$column"/"$prefix"-l5.qza --o-composition-table "$dir"/ancom-"$column"/"$prefix"-comp-l5.qza
qiime composition ancom --i-table  "$dir"/ancom-"$column"/"$prefix"-comp-l5.qza  --m-metadata-file "$metadata"  --m-metadata-column "$column" --o-visualization  "$dir"/ancom-"$column"/"$prefix"-level_5-ancom-"$column".qzv

qiime taxa collapse   --i-table "$i_table"  --i-taxonomy "$taxonomy"   --p-level 6 --o-collapsed-table "$dir"/ancom-"$column"/"$prefix"-l6.qza
qiime composition add-pseudocount   --i-table  "$dir"/ancom-"$column"/"$prefix"-l6.qza --o-composition-table "$dir"/ancom-"$column"/"$prefix"-comp-l6.qza
qiime composition ancom --i-table  "$dir"/ancom-"$column"/"$prefix"-comp-l6.qza  --m-metadata-file "$metadata"  --m-metadata-column "$column" --o-visualization  "$dir"/ancom-"$column"/"$prefix"-level_6-ancom-"$column".qzv

#ALDeX2

qiime aldex2 aldex2 --i-table "$i_table" --m-metadata-file "$metadata" --m-metadata-column "$column" --o-differentials "$dir"/aldex2-"$column"/differentials_"$prefix".qza --output-dir "$dir"/aldex2-"$column"
qiime aldex2 effect-plot --i-table "$dir"/aldex2-"$column"/differentials_"$prefix".qza --p-threshold 0.05 --o-visualization "$dir"/aldex2-"$column"/aldex2_"$prefix".qzv
qiime aldex2 extract-differences --i-table "$dir"/aldex2-"$column"/differentials_"$prefix".qza --o-differentials "$dir"/aldex2-"$column"/sig-features_"$prefix" \
--p-sig-threshold 1 \
--p-effect-threshold 1 \
--p-difference-threshold 0 2>>errors.txt
qiime tools export --input-path "$dir"/aldex2-"$column"/sig-features_"$prefix".qza --output-path "$dir"/aldex2-"$column" 2>>errors.txt
mv "$dir"/aldex2-"$column"/differentials.tsv "$dir"/aldex2-"$column"/aldex2_"$prefix".tsv 2>>errors.txt


qiime aldex2 aldex2 --i-table "$dir"/ancom-"$column"/"$prefix"-l2.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-differentials "$dir"/aldex2-"$column"/differentials_"$prefix"-l2.qza
qiime aldex2 effect-plot --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l2.qza --p-threshold 0.05 --o-visualization "$dir"/aldex2-"$column"/aldex2_"$prefix"-l2.qzv
qiime aldex2 extract-differences --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l2.qza --o-differentials "$dir"/aldex2-"$column"/sig-features_"$prefix"-l2 \
--p-sig-threshold 1 \
--p-effect-threshold 1 \
--p-difference-threshold 0 2>>errors.txt
qiime tools export --input-path "$dir"/aldex2-"$column"/sig-features_"$prefix"-l2.qza --output-path "$dir"/aldex2-"$column" 2>>errors.txt
mv "$dir"/aldex2-"$column"/differentials.tsv "$dir"/aldex2-"$column"/aldex2_"$prefix"-l2.tsv 2>>errors.txt

qiime aldex2 aldex2 --i-table "$dir"/ancom-"$column"/"$prefix"-l5.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-differentials "$dir"/aldex2-"$column"/differentials_"$prefix"-l5.qza
qiime aldex2 effect-plot --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l5.qza --p-threshold 0.05 --o-visualization "$dir"/aldex2-"$column"/aldex2_"$prefix"-l5.qzv
qiime aldex2 extract-differences --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l5.qza --o-differentials "$dir"/aldex2-"$column"/sig-features_"$prefix"-l5 \
--p-sig-threshold 1 \
--p-effect-threshold 1 \
--p-difference-threshold 0 2>>errors.txt
qiime tools export --input-path "$dir"/aldex2-"$column"/sig-features_"$prefix"-l5.qza --output-path "$dir"/aldex2-"$column" 2>>errors.txt
mv "$dir"/aldex2-"$column"/differentials.tsv "$dir"/aldex2-"$column"/aldex2_"$prefix"-l5.tsv 2>>errors.txt

qiime aldex2 aldex2 --i-table "$dir"/ancom-"$column"/"$prefix"-l6.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-differentials "$dir"/aldex2-"$column"/differentials_"$prefix"-l6.qza
qiime aldex2 effect-plot --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l6.qza --p-threshold 0.05 --o-visualization "$dir"/aldex2-"$column"/aldex2_"$prefix"-l6.qzv
qiime aldex2 extract-differences --i-table "$dir"/aldex2-"$column"/differentials_"$prefix"-l6.qza --o-differentials "$dir"/aldex2-"$column"/sig-features_"$prefix"-l6 \
--p-sig-threshold 1 \
--p-effect-threshold 1 \
--p-difference-threshold 0 2>>errors.txt
qiime tools export --input-path "$dir"/aldex2-"$column"/sig-features_"$prefix"-l6.qza --output-path "$dir"/aldex2-"$column" 2>>errors.txt
mv "$dir"/aldex2-"$column"/differentials.tsv "$dir"/aldex2-"$column"/aldex2_"$prefix"-l6.tsv 2>>errors.txt