#!/bin/bash
dir=$1
metadata=$2
group_column=$3
state_column=$4
state_1=$5
state_2=$6
subject_id=$7

mkdir "$dir"/Paiwise_"$group_column"
qiime longitudinal pairwise-differences \
--m-metadata-file "$metadata" \
--m-metadata-file "$dir"/shannon_vector.qza \
--p-metric shannon \
--p-group-column "$group_column" \
--p-state-column "$state_column" \
--p-state-1 "$state_1" \
--p-state-2 "$state_2" \
--p-individual-id-column "$subject_id" \
--p-replicate-handling random \
--o-visualization "$dir"/Paiwise_"$group_column"/Shannon_pairwise_"$group_column"_"$state_1"_"$state_2".qzv 

qiime longitudinal pairwise-differences \
--m-metadata-file "$metadata" \
--m-metadata-file "$dir"/faith_pd_vector.qza \
--p-metric faith_pd \
--p-group-column "$group_column" \
--p-state-column "$state_column" \
--p-state-1 "$state_1" \
--p-state-2 "$state_2" \
--p-individual-id-column "$subject_id" \
--p-replicate-handling random \
--o-visualization "$dir"/Paiwise_"$group_column"/Faith_pd_pairwise_"$group_column"_"$state_1"_"$state_2".qzv

qiime longitudinal pairwise-distances \
--i-distance-matrix "$dir"/weighted_unifrac_distance_matrix.qza \
--m-metadata-file "$metadata" \
--p-group-column "$group_column" \
--p-state-column "$state_column" \
--p-state-1 "$state_1" \
--p-state-2 "$state_2" \
--p-individual-id-column "$subject_id" \
--p-replicate-handling random \
--o-visualization "$dir"/Paiwise_"$group_column"/Weighted_pairwise_"$group_column"_"$state_1"_"$state_2".qzv


qiime longitudinal pairwise-distances \
--i-distance-matrix "$dir"/weighted_normalized_unifrac_distance_matrix.qza \
--m-metadata-file "$metadata" \
--p-group-column "$group_column" \
--p-state-column "$state_column" \
--p-state-1 "$state_1" \
--p-state-2 "$state_2" \
--p-individual-id-column "$subject_id" \
--p-replicate-handling random \
--o-visualization "$dir"/Paiwise_"$group_column"/Weighted_normalized_unifrac_pairwise_"$group_column"_"$state_1"_"$state_2".qzv

qiime longitudinal pairwise-distances \
--i-distance-matrix "$dir"/jaccard_distance_matrix.qza \
--m-metadata-file "$metadata" \
--p-group-column "$group_column" \
--p-state-column "$state_column" \
--p-state-1 "$state_1" \
--p-state-2 "$state_2" \
--p-individual-id-column "$subject_id" \
--p-replicate-handling random \
--o-visualization "$dir"/Paiwise_"$group_column"/Jaccard_pairwise_"$group_column"_"$state_1"_"$state_2".qzv

