#!/bin/bash

# Script for downloading assemblies

# Example usage:
# workingDir=./ \
# sbatch download_assemblies_round.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=24:00:00
#SBATCH --mem=1GB

# Job name and output
#SBATCH -J download
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Load samtools
module load samtools

# Navigate to working directory
pwd; hostname; date

echo "Navigating to working directory: "${workingDir}

cd ${workingDir}

# Make required directories
echo $(date +"[%b %d %H:%M:%S] Making required directories...")

mkdir -p primates
mkdir -p pholidota/manidae
mkdir -p carnivora/felidae
mkdir -p cetartiodactyla/tylopoda/camelidae
mkdir -p cetartiodactyla/suina/suidae
mkdir -p cetartiodactyla/cetruminantia/ruminantia/tragulidae
mkdir -p cetartiodactyla/cetruminantia/ruminantia/giraffidae
mkdir -p cetartiodactyla/cetruminantia/ruminantia/cervidae
mkdir -p cetartiodactyla/cetruminantia/ruminantia/bovidae
mkdir -p cetartiodactyla/cetruminantia/ruminantia/moschidae
mkdir -p cetartiodactyla/cetruminantia/whippomorpha/hippopotamidae
mkdir -p cetartiodactyla/cetruminantia/whippomorpha/cetacea/balaenopteridae
mkdir -p cetartiodactyla/cetruminantia/whippomorpha/cetacea/delpinidae

# download domestic cat assembly
echo $(date +"[%b %d %H:%M:%S] Downloading domestic cat assembly...")

cd ${workingDir}/carnivora/felidae
mkdir domestic_cat/
cd domestic_cat/
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/181/335/GCF_000181335.3_Felis_catus_9.0/GCF_000181335.3_Felis_catus_9.0_genomic.fna.gz -O GCF_000181335.3_Felis_catus_9.0.fa.gz
gzip -d GCF_000181335.3_Felis_catus_9.0.fa.gz

echo "Domestic cat assembly: "$(ls -d ${PWD}/GCF_000181335.3_Felis_catus_9.0.fa)

# download domestic dog assembly
echo $(date +"[%b %d %H:%M:%S] Downloading domestic dog assembly...")

cd ${workingDir}/carnivora/canidae
mkdir domestic_dog/
cd domestic_dog/
wget -c ftp://hgdownload.soe.ucsc.edu/goldenPath/canFam5/bigZips/canFam5.fa.gz -O canFam5.fa.gz
gzip -d canFam5.fa.gz

echo "Domestic dog assembly: "$(ls -d ${PWD}/canFam5.fa)

# download tree pangolin assembly
echo $(date +"[%b %d %H:%M:%S] Downloading tree pangolin assembly...")

cd ${workingDir}/pholidota/manidae
mkdir -p tree_pangolin/
cd tree_pangolin/
wget -c https://www.dropbox.com/s/llm55uchk07aizf/Jaziri_pseudohap2_scaffolds_HiC.fasta.gz?dl=0 -O Jaziri_pseudohap2_scaffolds_HiC.fa.gz
gzip -d Jaziri_pseudohap2_scaffolds_HiC.fa.gz

echo "Tree pangolin assembly: "$(ls -d ${PWD}/Jaziri_pseudohap2_scaffolds_HiC.fa)

# download horse assembly
echo $(date +"[%b %d %H:%M:%S] Downloading horse assembly...")

cd ${workingDir}/perissodactyla/equidae
mkdir horse/
cd horse/
wget -c ftp://hgdownload.soe.ucsc.edu/goldenPath/equCab3/bigZips/equCab3.fa.gz -O equCab3.fa.gz
gzip -d equCab3.fa.gz

echo "Horse assembly: "$(ls -d ${PWD}/equCab3.fa)

# download alpaca assembly
echo $(date +"[%b %d %H:%M:%S] Downloading alpaca assembly...")

cd ${workingDir}/cetartiodactyla/tylopoda/camelidae
mkdir alpaca
cd alpaca
wget -c https://www.dropbox.com/s/6gqx0iby3vbyo5g/Vicugna_pacos-2.0.1_HiC.fasta.gz?dl=0 -O Vicugna_pacos-2.0.1_HiC.fa.gz
gzip -d Vicugna_pacos-2.0.1_HiC.fa.gz

echo "Alpaca assembly: "$(ls -d ${PWD}/Vicugna_pacos-2.0.1_HiC.fa)

# download wild bactrian camel assembly
echo $(date +"[%b %d %H:%M:%S] Downloading wild bactrian camel assembly...")

cd ${workingDir}/cetartiodactyla/tylopoda/camelidae
mkdir wild_bactrian_camel
cd wild_bactrian_camel
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/834/535/GCF_009834535.1_BCGSAC_Cfer_1.0/GCF_009834535.1_BCGSAC_Cfer_1.0_genomic.fna.gz -O GCF_009834535.1_BCGSAC_Cfer_1.0.fa.gz
gzip -d GCF_009834535.1_BCGSAC_Cfer_1.0.fa.gz

echo "Wild bactrian camel assembly: "$(ls -d ${PWD}/GCF_009834535.1_BCGSAC_Cfer_1.0.fa)

# download hippopotamus assembly
echo $(date +"[%b %d %H:%M:%S] Downloading hippopotamus assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/whippomorpha/hippopotamidae
mkdir hippopotamus/
cd hippopotamus/
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/004/027/065/GCA_004027065.2_HipAmp_v2_BIUU_UCD/GCA_004027065.2_HipAmp_v2_BIUU_UCD_genomic.fna.gz -O GCA_004027065.2_HipAmp_v2_BIUU_UCD.fa.gz
gzip -d GCA_004027065.2_HipAmp_v2_BIUU_UCD.fa.gz

echo "Hippopotamus assembly: "$(ls -d ${PWD}/GCA_004027065.2_HipAmp_v2_BIUU_UCD.fa)

# download blue whale assembly
echo $(date +"[%b %d %H:%M:%S] Downloading blue whale assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/whippomorpha/cetacea/balaenopteridae
mkdir blue_whale/
cd blue_whale/
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/873/245/GCF_009873245.2_mBalMus1.pri.v3/GCF_009873245.2_mBalMus1.pri.v3_genomic.fna.gz -O GCF_009873245.2_mBalMus1.pri.v3.fa.gz
gzip -d GCF_009873245.2_mBalMus1.pri.v3.fa.gz

echo "Blue whale assembly: "$(ls -d ${PWD}/GCF_009873245.2_mBalMus1.pri.v3.fa)

# download common bottlenose dolphin assembly
echo $(date +"[%b %d %H:%M:%S] Downloading common bottlenose dolphin assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/whippomorpha/cetacea/delpinidae
mkdir common_bottlenose_dolphin/
cd common_bottlenose_dolphin/
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/011/762/595/GCF_011762595.1_mTurTru1.mat.Y/GCF_011762595.1_mTurTru1.mat.Y_genomic.fna.gz -O GCF_011762595.1_mTurTru1.mat.Y.fa.gz
gzip -d GCF_011762595.1_mTurTru1.mat.Y.fa.gz

echo "Common bottlenose dolphin assembly: "$(ls -d ${PWD}/GCF_011762595.1_mTurTru1.mat.Y.fa)

# download java mouse-deer assembly
echo $(date +"[%b %d %H:%M:%S] Downloading java mouse-deer assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/tragulidae
mkdir java_mouse_deer/
cd java_mouse_deer/
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/004/024/965/GCA_004024965.2_ASM402496v2/GCA_004024965.2_ASM402496v2_genomic.fna.gz -O GCA_004024965.2_ASM402496v2.fa.gz
gzip -d GCA_004024965.2_ASM402496v2.fa.gz

echo "Java mouse-deer assembly: "$(ls -d ${PWD}/GCA_004024965.2_ASM402496v2.fa)

# download forest musk deer assembly
echo $(date +"[%b %d %H:%M:%S] Downloading forest musk deer assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/moschidae
mkdir forest_musk_deer/
cd forest_musk_deer/
wget -c https://www.dropbox.com/s/v0yg4cdsyodktb0/ls35.final.genome_HiC.fasta.gz?dl=0 -O ls35.final.genome_HiC.fa.gz
gzip -d ls35.final.genome_HiC.fa.gz

echo "Forest musk deer assembly: "$(ls -d ${PWD}/ls35.final.genome_HiC.fa)

# download cattle assembly
echo $(date +"[%b %d %H:%M:%S] Downloading cattle assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/bovidae
mkdir cattle/
cd cattle/
wget -c https://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/bosTau9.fa.gz -O bosTau9.fa.gz
gzip -d bosTau9.fa.gz

echo "Cattle assembly: "$(ls -d ${PWD}/bosTau9.fa)

# download eastern bongo assembly
echo $(date +"[%b %d %H:%M:%S] Downloading eastern bongo assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/bovidae
mkdir eastern_bongo/
cd eastern_bongo/
wget -c https://www.dropbox.com/s/5841u0iz0eolzis/barney_pseudo2.1_HiC.fasta.gz?dl=0 -O barney_pseudo2.1_HiC.fa.gz
gzip -d barney_pseudo2.1_HiC.fa.gz

echo "Eastern bongo assembly: "$(ls -d ${PWD}/barney_pseudo2.1_HiC.fa)

# download scimitar-horned oryx assembly
echo $(date +"[%b %d %H:%M:%S] Downloading scimitar-horned oryx assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/bovidae
mkdir scimitar_horned_oryx/
cd scimitar_horned_oryx/
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/014/754/425/GCF_014754425.2_SCBI_Odam_1.1/GCF_014754425.2_SCBI_Odam_1.1_genomic.fna.gz -O GCF_014754425.2_SCBI_Odam_1.1.fa.gz
gzip -d GCF_014754425.2_SCBI_Odam_1.1.fa.gz

echo "Scimitar-horned oryx assembly: "$(ls -d ${PWD}/GCF_014754425.2_SCBI_Odam_1.1.fa)

# download blue wildebeest assembly
echo $(date +"[%b %d %H:%M:%S] Downloading blue wildebeest assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/bovidae
mkdir blue_wildebeest/
cd blue_wildebeest/
wget -c https://www.dropbox.com/s/yerjhcwfvsw8ygk/BWD_HiC.fasta.gz?dl=0 -O BWD_HiC.fa.gz
gzip -d BWD_HiC.fa.gz

echo "Blue wildebeest assembly: "$(ls -d ${PWD}/BWD_HiC.fa)

# download domestic goat assembly
echo $(date +"[%b %d %H:%M:%S] Downloading domestic goat assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/bovidae
mkdir domestic_goat/
cd domestic_goat/
wget -c ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/001/704/415/GCA_001704415.1_ARS1/GCA_001704415.1_ARS1_genomic.fna.gz -O ARS1_GCA_001704415.1.fa.gz
gzip -d ARS1_GCA_001704415.1.fa.gz

echo "Domestic goat assembly: "$(ls -d ${PWD}/ARS1_GCA_001704415.1.fa)

# download sheep assembly
echo $(date +"[%b %d %H:%M:%S] Downloading sheep assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/bovidae
mkdir sheep/
cd sheep/
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/016/772/045/GCA_016772045.1_ARS-UI_Ramb_v2.0/GCA_016772045.1_ARS-UI_Ramb_v2.0_genomic.fna.gz -O GCA_016772045.1_ARS-UI_Ramb_v2.0.fa.gz
gzip -d GCA_016772045.1_ARS-UI_Ramb_v2.0.fa.gz

echo "Sheep assembly: "$(ls -d ${PWD}/GCA_016772045.1_ARS-UI_Ramb_v2.0.fa)

# download gerenuk assembly
echo $(date +"[%b %d %H:%M:%S] Downloading gerenuk assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/bovidae
mkdir gerenuk/
cd gerenuk/
wget -c https://www.dropbox.com/s/00kobnj3odjompt/GRK_HiC.fasta.gz?dl=0 -O GRK_HiC.fa.gz
gzip -d GRK_HiC.fa.gz

echo "Gerenuk assembly: "$(ls -d ${PWD}/GRK_HiC.fa)

# download giraffe assembly
echo $(date +"[%b %d %H:%M:%S] Downloading giraffe assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/giraffidae
mkdir giraffe/
cd giraffe/
wget -c https://www.dropbox.com/s/5m72wriz9u6tx8c/ASM165123v1_HiC.fasta.gz?dl=0 -O ASM165123v1_HiC.fa.gz
gzip -d ASM165123v1_HiC.fa.gz

echo "Giraffe assembly: "$(ls -d ${PWD}/ASM165123v1_HiC.fa)

# download mule deer
echo $(date +"[%b %d %H:%M:%S] Downloading mule deer assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/cervidae
mkdir mule_deer/
cd mule_deer/
wget -c https://www.dropbox.com/s/mw2edcyfi0qy7q0/Odocoileus_hemionus_HiC.fasta.gz?dl=0 -O Odocoileus_hemionus_HiC.fa.gz
gzip -d Odocoileus_hemionus_HiC.fa.gz

echo "Mule deer assembly: "$(ls -d ${PWD}/Odocoileus_hemionus_HiC.fa)

# download Reeve's muntjac assembly
echo $(date +"[%b %d %H:%M:%S] Downloading Reeve's muntjac assembly assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/cervidae
mkdir reeves_muntjac/
cd reeves_muntjac/
wget -c https://www.dropbox.com/s/qqq5m2rz3c4vb38/CIJ_HiC.fasta.gz?dl=0 -O CIJ_HiC.fa.gz
gzip -d CIJ_HiC.fa.gz

echo "Reeve's muntjac assembly: "$(ls -d ${PWD}/CIJ_HiC.fa)

# download Central European red deer assembly
echo $(date +"[%b %d %H:%M:%S] Downloading Central European red deer assembly...")

cd ${workingDir}/cetartiodactyla/cetruminantia/ruminantia/cervidae
mkdir central_european_red_deer/
cd central_european_red_deer/
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/002/197/005/GCA_002197005.1_CerEla1.0/GCA_002197005.1_CerEla1.0_genomic.fna.gz -O GCA_002197005.1_CerEla1.0.fa.gz
gzip -d GCA_002197005.1_CerEla1.0.fa.gz

echo "Central European red deer assembly: "$(ls -d ${PWD}/GCA_002197005.1_CerEla1.0.fa)

# download domestic pig assembly
echo $(date +"[%b %d %H:%M:%S] Downloading domestic pig assembly...")

cd ${workingDir}/cetartiodactyla/suina/suidae
mkdir domestic_pig
cd domestic_pig
wget -c ftp://hgdownload.soe.ucsc.edu/goldenPath/susScr11/bigZips/susScr11.fa.gz -O susScr11.fa.gz
gzip -d susScr11.fa.gz

echo "Domestic pig assembly: "$(ls -d ${PWD}/susScr11.fa)

# download human assembly
echo $(date +"[%b %d %H:%M:%S] Downloading human assembly...")

cd ${workingDir}/primates
mkdir human/
cd human/
wget -c https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gzip -d hg38.fa.gz

wget https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.chrom.sizes
grep -Ev "alt|chrUn|random" hg38.chrom.sizes > hg38.main.chrom.sizes
awk '{print $1}' hg38.main.chrom.sizes > hg38.main.chrom.names
xargs samtools faidx hg38.fa > hg38.main.fa < hg38.main.chrom.names

rm hg38.fa hg38.fa.fai hg38.chrom.sizes hg38.main.chrom.names

echo "Human assembly: "$(ls -d ${PWD}/human.main.fa)

echo $(date +"[%b %d %H:%M:%S] Done")