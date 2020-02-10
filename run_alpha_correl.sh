#!/bin/bash

dir=$1
metadata=$2
column=$3


#Alpha-correlation
qiime diversity alpha-correlation --i-alpha-diversity  "$dir"/faith_pd_vector.qza  --m-metadata-file "$metadata" --o-visualization "$dir"/faith_correl_"$column".qzv 
qiime diversity alpha-correlation --i-alpha-diversity  "$dir"/shannon_vector.qza  --m-metadata-file "$metadata" --o-visualization "$dir"/shannon_correl_"$column".qzv
qiime diversity alpha-correlation --i-alpha-diversity  "$dir"/observed_otus_vector.qza  --m-metadata-file "$metadata" --o-visualization "$dir"/richness_correl_"$column".qzv
