#!/bin/bash

# Each RepeatMasker SLURM job is allocated 20 threads and 150GB
# You may want to run the script calls (below) in batches

# domestic cat
workingDir=./carnivora/felidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# domestic dog
workingDir=./canidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# tree pangolin
workingDir=./pholidota/manidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# horse
workingDir=./perissodactyla \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# camelids
workingDir=./cetartiodactyla/tylopoda/camelidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0-1 RepeatMasker.sbatch

# hippopotamus
workingDir=./cetartiodactyla/cetruminantia/whippomorpha/hippopotamidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# blue whale
workingDir=./cetartiodactyla/cetruminantia/whippomorpha/cetacea/balaenopteridae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# common bottlenose dolphin
workingDir=./cetartiodactyla/cetruminantia/whippomorpha/cetacea/delphinidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# java mouse deer
workingDir=./cetartiodactyla/cetruminantia/ruminantia/tragulidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# forest musk deer
workingDir=./cetartiodactyla/cetruminantia/ruminantia/moschidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# bovids
workingDir=./cetartiodactyla/cetruminantia/ruminantia/bovidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0-6 RepeatMasker.sbatch

# giraffe
workingDir=./cetartiodactyla/cetruminantia/ruminantia/giraffidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# cervids
workingDir=./cetartiodactyla/cetruminantia/ruminantia/cervidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0-2 RepeatMasker.sbatch

# domestic pig
workingDir=./cetartiodactyla/suina/suidae \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch

# human
workingDir=./primates \
libFile=./RMRBSeqs.fasta \
sbatch --array=0 RepeatMasker.sbatch