#!/usr/bin/env bash

input_dir=$1
output_dir=$2

mkdir -p "$output_dir"
echo $input_dir

temp_dir=$(mktemp -d)

cp "$input_dir"/*.bam "$temp_dir"
log_file="${output_dir}/log.txt"
touch "$log_file"

source $(output_dir $(output_dir $(mambaforge)))/etc/profile.d/conda.sh
source ~/mambaforge/etc/profile.d/conda.sh
conda create --name bam2bigwig --yes
conda activate bam2bigwig
conda install samtools
conda install bamCoverage
conda install deeptools

for bam_file in "$temp_dir"/*.bam; do
    if [ -e "$bam_file" ]; then
        echo "Processing file: $bam_file"
        base_name=$(basename "$bam_file" .bam)
        # Run samtools index
        samtools index "$bam_file"
        # Run bamCoverage
       nice  bamCoverage -b "$bam_file" -o "$temp_dir/$base_name.bw" &>> $log_file
    fi
done

cp "$temp_dir"/*.bw "$output_dir"
cp "$temp_dir"/*.txt "$output_dir"

rm -rf "$temp_dir"

echo "Laura Smolders"

