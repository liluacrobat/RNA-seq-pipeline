#!/bin/sh
#SBATCH --partition=general-compute
#SBATCH --qos=general-compute
#SBATCH --time=71:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=300000
#SBATCH --job-name="ENCODE-RNA1"
#SBATCH --output=ENCODE-RNA1.log
#SBATCH --mail-user=lli59@buffalo.edu
#SBATCH --mail-type=ALL

module load qiime2
conda activate /projects/academic/pidiazmo/projectsoftwares/encode/rna-seq

caper run rna-seq-pipeline.wdl -m testrun_metadata1.json -i PE_stranded_input1.json -b local --singularity
echo 'Caper Succeed'
echo '--------------------'
