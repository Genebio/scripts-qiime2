#!/bin/bash
dir=$1
cd /home/korenlab/pintoy/$dir
sleep 10s
qiime vsearch join-pairs   --i-demultiplexed-seqs demux_paired_golay.qza --o-joined-sequences demux-joined.qza
qiime quality-filter q-score-joined   --i-demux demux-joined.qza   --o-filtered-sequences demux-joined-filtered.qza   --o-filter-stats demux-joined-filter-stats.qza --p-min-quality 20
qiime metadata tabulate --m-input-file demux-joined-filtered.qza --o-visualization demux-joined-filtered.qzv
qiime deblur denoise-16S   --i-demultiplexed-seqs demux-joined-filtered.qza   --p-trim-length 250   --p-sample-stats   --o-representative-sequences rep-seqs.qza   --o-table table.qza   --o-stats deblur-stats.qza
qiime feature-table summarize   --i-table table.qza   --o-visualization table_joined_deblur.qzv