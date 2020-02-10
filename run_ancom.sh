#!/bin/bash
file=$1
dir=$2
metadata=$3
column=$4
taxonomy=$5

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