#!/bin/bash
#source qiime2
data_dir=$1
barcodes_file=$2

mkdir "$data_dir"_single_end_sequences
ln "$data_dir"/Undetermined_S0_L001_R1_001.fastq.gz "$data_dir"_single_end_sequences/sequences.fastq.gz
ln "$data_dir"/Undetermined_S0_L001_I1_001.fastq.gz "$data_dir"_single_end_sequences/barcodes.fastq.gz

qiime tools import --type EMPSingleEndSequences --input-path "$data_dir"_single_end_sequences --output-path "$data_dir"_single_end_sequences/single_end_sequences.qza
qiime demux emp-single --m-barcodes-file "$barcodes_file" --m-barcodes-column BarcodeSequence --i-seqs "$data_dir"_single_end_sequences/single_end_sequences.qza --o-per-sample-sequences "$data_dir"_single_end_sequences/demux_single.qza --o-error-correction-details ./"$data_dir"_single_end_sequences/demux-details.qza --p-rev-comp-barcodes --p-rev-comp-mapping-barcodes
qiime demux summarize --i-data "$data_dir"_single_end_sequences/demux_single.qza --o-visualization "$data_dir"_single_end_sequences/demux_single_visual.qzv
