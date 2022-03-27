#!/bin/bash

# Script for copying and renaming RepeatMasker output files

# Example usage:
# cd /Users/coke6162/repos/project_files/20210407_MER41_lineage_tracing
# sbatch copy_RM_output_and_rename.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=2:00:00
#SBATCH --mem=1GB

# Job name and output
#SBATCH -J RepeatMasker
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Make directory
pwd; hostname; date

mkdir all_output/

# Copying files
echo $(date +"[%b %d %H:%M:%S] Copying files...")

cp primates/human/*.fa.out all_output/
cp pholidota/manidae/tree_pangolin/*.fa.out all_output/
cp carnivora/felidae/domestic_cat/*.fa.out all_output/
cp carnivora/canidae/domestic_dog/*.fa.out all_output/
cp perissodactyla/equidae/horse/*.fa.out all_output/
cp cetartiodactyla/tylopoda/camelidae/alpaca/*.fa.out all_output/
cp cetartiodactyla/tylopoda/camelidae/wild_bactrian_camel/*.fa.out all_output/
cp cetartiodactyla/suina/suidae/domestic_pig/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/tragulidae/java_mouse_deer/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/giraffidae/giraffe/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/cervidae/central_european_red_deer/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/cervidae/reeves_muntjac/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/cervidae/mule_deer/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/bovidae/blue_wildebeest/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/bovidae/gerenuk/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/bovidae/eastern_bongo/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/bovidae/sheep/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/bovidae/scimitar_horned_oryx/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/bovidae/cattle/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/bovidae/domestic_goat/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/ruminantia/moschidae/forest_musk_deer/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/whippomorpha/hippopotamidae/hippopotamus/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/whippomorpha/cetacea/balaenopteridae/blue_whale/*.fa.out all_output/
cp cetartiodactyla/cetruminantia/whippomorpha/cetacea/delpinidae/common_bottlenose_dolphin/*.fa.out all_output/

# Move into output directory
echo $(date +"[%b %d %H:%M:%S] Moving into output directory...")

cd all_output/

# Rename files
echo $(date +"[%b %d %H:%M:%S] Renaming files...")

rename hg38.main human *hg38.main*
rename Jaziri_pseudohap2_scaffolds_HiC tree_pangolin *Jaziri_pseudohap2_scaffolds_HiC*
rename GCF_000181335.3_Felis_catus_9.0 domestic_cat *GCF_000181335.3_Felis_catus_9.0*
rename canFam5 domestic_dog *canFam5*
rename equCab3 horse *equCab3*
rename Vicugna_pacos-2.0.1_HiC alpaca *Vicugna_pacos-2.0.1_HiC*
rename GCF_009834535.1_BCGSAC_Cfer_1.0 wild_bactrian_camel *GCF_009834535.1_BCGSAC_Cfer_1.0*
rename susScr11 domestic_pig *susScr11*
rename GCA_004024965.2_ASM402496v2 java_mouse_deer *GCA_004024965.2_ASM402496v2*
rename ASM165123v1_HiC giraffe *ASM165123v1_HiC*
rename GCA_002197005.1_CerEla1.0 central_european_red_deer *GCA_002197005.1_CerEla1.0*
rename CIJ_HiC reeves_muntjac *CIJ_HiC*
rename Odocoileus_hemionus_HiC mule_deer *Odocoileus_hemionus_HiC*
rename BWD_HiC blue_wildebeest *BWD_HiC*
rename GRK_HiC gerenuk *GRK_HiC*
rename barney_pseudo2.1_HiC eastern_bongo *barney_pseudo2.1_HiC*
rename GCA_016772045.1_ARS-UI_Ramb_v2.0 sheep *GCA_016772045.1_ARS-UI_Ramb_v2.0*
rename GCF_014754425.2_SCBI_Odam_1.1 scimitar_horned_oryx *GCF_014754425.2_SCBI_Odam_1.1*
rename bosTau9 cattle *bosTau9*
rename ARS1_GCA_001704415.1 domestic_goat *ARS1_GCA_001704415.1*
rename ls35.final.genome_HiC forest_musk_deer *ls35.final.genome_HiC*
rename GCA_004027065.2_HipAmp_v2_BIUU_UCD hippopotamus *GCA_004027065.2_HipAmp_v2_BIUU_UCD*
rename GCF_009873245.2_mBalMus1.pri.v3 blue_whale *GCF_009873245.2_mBalMus1.pri.v3*
rename GCF_011762595.1_mTurTru1.mat.Y common_bottlenose_dolphin *GCF_011762595.1_mTurTru1.mat*

echo $(date +"[%b %d %H:%M:%S] Done")