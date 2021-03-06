#!/bin/bash

dir=$1
metadata=$2
column=$3


#Beta-correlation
qiime diversity beta-correlation \
--i-distance-matrix "$dir"/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file "$metadata" \
--m-metadata-column "$column" \
--p-intersect-ids \
--o-metadata-distance-matrix "$dir"/unweighted_unifrac_metadata_distance_matrix_"$column".qza \
--o-mantel-scatter-visualization "$dir"/unweighted_unifrac_correl_"$column".qzv

qiime diversity beta-correlation \
--i-distance-matrix "$dir"/weighted_unifrac_distance_matrix.qza \
--m-metadata-file "$metadata" \
--m-metadata-column "$column" \
--p-intersect-ids \
--o-metadata-distance-matrix "$dir"/weighted_unifrac_metadata_distance_matrix_"$column".qza \
--o-mantel-scatter-visualization "$dir"/weighted_unifrac_correl_"$column".qzv

qiime diversity beta-correlation \
--i-distance-matrix "$dir"/bray_curtis_distance_matrix.qza \
--m-metadata-file "$metadata" \
--m-metadata-column "$column" \
--p-intersect-ids \
--o-metadata-distance-matrix "$dir"/bray_curtis_metadata_distance_matrix_"$column".qza \
--o-mantel-scatter-visualization "$dir"/bray_curtis_correl_"$column".qzv
