#!/bin/bash
i_table=$1
metadata=$2
dir=$3
group_column=$4
state_column=$5
subject_id=$6


mkdir "$dir"/Longitudinal_"$group_column"

#Alpha-diversity classic longitudinal-LME
qiime longitudinal linear-mixed-effects --m-metadata-file "$metadata" --m-metadata-file "$dir"/faith_pd_vector.qza --p-metric faith_pd \
--p-group-columns "$group_column" --p-state-column "$state_column" --p-individual-id-column "$subject_id" \
--o-visualization "$dir"/Longitudinal_"$group_column"/LME_"$dir"_faith_pd_"$group_column"_"$state_column".qzv

qiime longitudinal linear-mixed-effects --m-metadata-file "$metadata" --m-metadata-file "$dir"/shannon_vector.qza --p-metric shannon \
--p-group-columns "$group_column" --p-state-column "$state_column" --p-individual-id-column "$subject_id" \
--o-visualization "$dir"/Longitudinal_"$group_column"/LME_"$dir"_shannon_"$group_column"_"$state_column".qzv


#Alpha-diversity first differences-LME
qiime longitudinal first-differences --m-metadata-file "$metadata" --m-metadata-file "$dir"/faith_pd_vector.qza --p-state-column "$state_column" --p-metric faith_pd \
--p-individual-id-column "$subject_id" --p-replicate-handling random \
--o-first-differences "$dir"/Longitudinal_"$group_column"/faith_pd_"$group_column"_"$state_column"-first-differences.qza
qiime longitudinal linear-mixed-effects --m-metadata-file "$metadata" --m-metadata-file "$dir"/Longitudinal_"$group_column"/faith_pd_"$group_column"_"$state_column"-first-differences.qza \
--p-metric Difference --p-group-columns "$group_column" --p-state-column "$state_column" --p-individual-id-column "$subject_id" \
--o-visualization "$dir"/Longitudinal_"$group_column"/Longitudinal_"$dir"_faith_pd_"$group_column"_"$state_column".qzv

qiime longitudinal first-differences --m-metadata-file "$metadata" --m-metadata-file "$dir"/shannon_vector.qza --p-state-column "$state_column" --p-metric shannon \
--p-individual-id-column "$subject_id" --p-replicate-handling random \
--o-first-differences "$dir"/Longitudinal_"$group_column"/shannon_"$group_column"_"$state_column"-first-differences.qza
qiime longitudinal linear-mixed-effects --m-metadata-file "$metadata" --m-metadata-file "$dir"/Longitudinal_"$group_column"/shannon_"$group_column"_"$state_column"-first-differences.qza \
--p-metric Difference --p-group-columns "$group_column" --p-state-column "$state_column" --p-individual-id-column "$subject_id" \
--o-visualization "$dir"/Longitudinal_"$group_column"/shannon_"$group_column"_"$state_column"-first-differences-LME.qzv


#Beta-diversity first distances-LME
qiime longitudinal first-distances --i-distance-matrix "$dir"/jaccard_distance_matrix.qza --m-metadata-file "$metadata" --p-state-column "$state_column" --p-individual-id-column "$subject_id" \
--p-replicate-handling random --o-first-distances "$dir"/Longitudinal_"$group_column"/jaccard_"$group_column"_"$state_column"-first-disctances.qza
qiime longitudinal linear-mixed-effects --m-metadata-file "$metadata" --m-metadata-file "$dir"/Longitudinal_"$group_column"/jaccard_"$group_column"_"$state_column"-first-disctances.qza \
--p-metric Distance --p-group-columns "$group_column" --p-state-column "$state_column" --p-individual-id-column "$subject_id" \
--o-visualization "$dir"/Longitudinal_"$group_column"/jaccard_"$group_column"_"$state_column"-first-distances-LME.qzv

qiime longitudinal first-distances --i-distance-matrix "$dir"/weighted_unifrac_distance_matrix.qza --m-metadata-file "$metadata" --p-state-column "$state_column" --p-individual-id-column "$subject_id" \
--p-replicate-handling random --o-first-distances "$dir"/Longitudinal_"$group_column"/weighted_unifrac_"$group_column"_"$state_column"-first-disctances.qza
qiime longitudinal linear-mixed-effects --m-metadata-file "$metadata" --m-metadata-file "$dir"/Longitudinal_"$group_column"/weighted_unifrac_"$group_column"_"$state_column"-first-disctances.qza \
--p-metric Distance --p-group-columns "$group_column" --p-state-column "$state_column" --p-individual-id-column "$subject_id" \
--o-visualization "$dir"/Longitudinal_"$group_column"/weighted_unifrac_"$group_column"_"$state_column"-first-distances-LME.qzv


qiime longitudinal first-distances --i-distance-matrix "$dir"/weighted_normalized_unifrac_distance_matrix.qza \
--m-metadata-file "$metadata" --p-state-column "$state_column" --p-individual-id-column "$subject_id" --p-replicate-handling random \
--o-first-distances "$dir"/Longitudinal_"$group_column"/weighted_normalized_unifrac_"$group_column"_"$state_column"-first-disctances.qza
qiime longitudinal linear-mixed-effects --m-metadata-file "$metadata" --m-metadata-file "$dir"/Longitudinal_"$group_column"/weighted_normalized_unifrac_"$group_column"_"$state_column"-first-disctances.qza \
--p-metric Distance --p-group-columns "$group_column" --p-state-column "$state_column" --p-individual-id-column "$subject_id" \
--o-visualization "$dir"/Longitudinal_"$group_column"/weighted_normalized_unifrac_"$group_column"_"$state_column"-first-distances-LME.qzv


qiime longitudinal first-distances --i-distance-matrix "$dir"/bray_curtis_distance_matrix.qza \
--m-metadata-file "$metadata" --p-state-column "$state_column" --p-individual-id-column "$subject_id" --p-replicate-handling random \
--o-first-distances "$dir"/Longitudinal_"$group_column"/bray_curtis_"$group_column"_"$state_column"-first-disctances.qza
qiime longitudinal linear-mixed-effects --m-metadata-file "$metadata" --m-metadata-file "$dir"/Longitudinal_"$group_column"/bray_curtis_"$group_column"_"$state_column"-first-disctances.qza \
--p-metric Distance --p-group-columns "$group_column" --p-state-column "$state_column" --p-individual-id-column "$subject_id" \
--o-visualization "$dir"/Longitudinal_"$group_column"/bray_curtis_"$group_column"_"$state_column"-first-distances-LME.qzv

#Beta-diversity NMIT 
prefix=${i_table%.qza}
qiime feature-table relative-frequency --i-table "$i_table" --o-relative-frequency-table "$dir"/Longitudinal_"$group_column"/"$prefix"_rel_abund.qza

qiime longitudinal nmit --i-table "$dir"/Longitudinal_"$group_column"/"$prefix"_rel_abund.qza --m-metadata-file "$metadata" --p-individual-id-column "$subject_id" --p-corr-method pearson \
--o-distance-matrix "$dir"/Longitudinal_"$group_column"/nmit-dm.qza

qiime diversity beta-group-significance --i-distance-matrix "$dir"/Longitudinal_"$group_column"/nmit-dm.qza --m-metadata-file "$metadata" --m-metadata-column "$group_column" \
--o-visualization "$dir"/Longitudinal_"$group_column"/nmit_"$group_column"_statistics.qzv

qiime diversity pcoa --i-distance-matrix "$dir"/Longitudinal_"$group_column"/nmit-dm.qza --o-pcoa "$dir"/Longitudinal_"$group_column"/nmit-pc.qza
qiime emperor plot --i-pcoa "$dir"/Longitudinal_"$group_column"/nmit-pc.qza --m-metadata-file "$metadata" --o-visualization "$dir"/Longitudinal_"$group_column"/nmit_"$group_column"_emperor.qzv

rm -f "$dir"/Longitudinal_"$group_column"/*.qza
