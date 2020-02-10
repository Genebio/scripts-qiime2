#!/bin/bash
metadata=$1
dir=$2
group_column=$3
state_column=$4
subject_id=$5


mkdir "$dir"/LME_"$group_column"
qiime longitudinal linear-mixed-effects \
--m-metadata-file "$metadata" \
--m-metadata-file "$dir"/faith_pd_vector.qza \
--p-metric faith_pd \
--p-group-columns "$group_column" \
--p-state-column "$state_column" \
--p-individual-id-column "$subject_id" \
--o-visualization "$dir"/LME_"$group_column"/LME_"$dir"_faith_pd_"$group_column"_"$state_column".qzv

qiime longitudinal linear-mixed-effects \
--m-metadata-file "$metadata" \
--m-metadata-file "$dir"/shannon_vector.qza \
--p-metric shannon \
--p-group-columns "$group_column" \
--p-state-column "$state_column" \
--p-individual-id-column "$subject_id" \
--o-visualization "$dir"/LME_"$group_column"/LME_"$dir"_shannon_"$group_column"_"$state_column".qzv

qiime longitudinal linear-mixed-effects \
--m-metadata-file "$metadata" \
--m-metadata-file "$dir"/unweighted_unifrac_pcoa_results.qza \
--p-metric Axis\ 1 \
--p-group-columns "$group_column" \
--p-state-column "$state_column" \
--p-individual-id-column "$subject_id" \
--o-visualization "$dir"/LME_"$group_column"/LME_"$dir"_unweighted_"$group_column"_"$state_column".qzv

qiime longitudinal linear-mixed-effects \
--m-metadata-file "$metadata" \
--m-metadata-file "$dir"/weighted_unifrac_pcoa_results.qza \
--p-metric Axis\ 1 \
--p-group-columns "$group_column" \
--p-state-column "$state_column" \
--p-individual-id-column "$subject_id" \
--o-visualization "$dir"/LME_"$group_column"/LME_"$dir"_weighted_"$group_column"_"$state_column".qzv

qiime longitudinal linear-mixed-effects \
--m-metadata-file "$metadata" \
--m-metadata-file "$dir"/jaccard_pcoa_results.qza \
--p-metric Axis\ 1 \
--p-group-columns "$group_column" \
--p-state-column "$state_column" \
--p-individual-id-column "$subject_id" \
--o-visualization "$dir"/LME_"$group_column"/LME_"$dir"_jaccard_"$group_column"_"$state_column".qzv