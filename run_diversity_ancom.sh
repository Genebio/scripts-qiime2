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

#Alpha
qiime diversity alpha-group-significance --i-alpha-diversity  "$dir"/faith_pd_vector.qza  --m-metadata-file "$metadata" --o-visualization "$dir"/faith_pd_statistics.qzv 
qiime diversity alpha-group-significance --i-alpha-diversity  "$dir"/shannon_vector.qza  --m-metadata-file "$metadata" --o-visualization "$dir"/shannon_statistics.qzv 

#Beta
qiime diversity beta-group-significance --i-distance-matrix "$dir"/unweighted_unifrac_distance_matrix.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-visualization "$dir"/unweighted_unifrac-"$column"-significance.qzv
qiime diversity beta-group-significance --i-distance-matrix "$dir"/weighted_unifrac_distance_matrix.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-visualization "$dir"/weighted_unifrac-"$column"-significance.qzv
qiime diversity beta-group-significance --i-distance-matrix "$dir"/weighted_normalized_unifrac_distance_matrix.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-visualization "$dir"/weighted_normalized_unifrac-"$column"-significance.qzv
qiime diversity beta-group-significance --i-distance-matrix "$dir"/bray_curtis_distance_matrix.qza --m-metadata-file "$metadata" --m-metadata-column "$column" --o-visualization "$dir"/bray_curtis-"$column"-significance.qzv


#ANCOM
prefix=${i_table%.qza}

qiime composition add-pseudocount   --i-table "$i_table" --output-dir "$dir"/ancom --o-composition-table "$dir"/ancom/"$prefix"_comp.qza
qiime composition ancom --i-table  "$dir"/ancom/"$prefix"_comp.qza  --m-metadata-file "$metadata"  --m-metadata-column "$column" --o-visualization  "$dir"/ancom/"$prefix"-ancom-"$column".qzv

qiime taxa collapse   --i-table "$i_table"  --i-taxonomy "$taxonomy"   --p-level 2 --o-collapsed-table "$dir"/ancom/"$prefix"-l2.qza
qiime composition add-pseudocount   --i-table  "$dir"/ancom/"$prefix"-l2.qza --o-composition-table "$dir"/ancom/"$prefix"-comp-l2.qza
qiime composition ancom --i-table  "$dir"/ancom/"$prefix"-comp-l2.qza  --m-metadata-file "$metadata"  --m-metadata-column "$column" --o-visualization  "$dir"/ancom/"$prefix"-level_2-ancom-"$column".qzv

qiime taxa collapse   --i-table "$i_table"  --i-taxonomy "$taxonomy"   --p-level 5 --o-collapsed-table "$dir"/ancom/"$prefix"-l5.qza
qiime composition add-pseudocount   --i-table  "$dir"/ancom/"$prefix"-l5.qza --o-composition-table "$dir"/ancom/"$prefix"-comp-l5.qza
qiime composition ancom --i-table  "$dir"/ancom/"$prefix"-comp-l5.qza  --m-metadata-file "$metadata"  --m-metadata-column "$column" --o-visualization  "$dir"/ancom/"$prefix"-level_5-ancom-"$column".qzv

qiime taxa collapse   --i-table "$i_table"  --i-taxonomy "$taxonomy"   --p-level 6 --o-collapsed-table "$dir"/ancom/"$prefix"-l6.qza
qiime composition add-pseudocount   --i-table  "$dir"/ancom/"$prefix"-l6.qza --o-composition-table "$dir"/ancom/"$prefix"-comp-l6.qza
qiime composition ancom --i-table  "$dir"/ancom/"$prefix"-comp-l6.qza  --m-metadata-file "$metadata"  --m-metadata-column "$column" --o-visualization  "$dir"/ancom/"$prefix"-level_6-ancom-"$column".qzv