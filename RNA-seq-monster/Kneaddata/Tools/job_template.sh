#!/bin/sh
#SBATCH --cluster=ub-hpc
#SBATCH --partition=general-compute
#SBATCH --qos=general-compute
#SBATCH --time=71:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=30000
#SBATCH --job-name="KD-__SAMPLE_ID__"
#SBATCH --output=KD-__SAMPLE_ID__.log

eval "$(/util/common/python/py38/anaconda-2020.07/bin/conda shell.bash hook)"
conda activate /projects/academic/pidiazmo/projectsoftwares/kneaddata/kneaddata


echo '--------------------'
echo 'Filtering ...'

# If samples are from human, we can use only the hg37 database for host removal
kneaddata --input ../__SAMPLE_ID___R1_001.fastq --input ../__SAMPLE_ID___R2_001.fastq -db /projects/academic/pidiazmo/projectsoftwares/kneaddata/hg37_ref -db /projects/academic/pidiazmo/projectsoftwares/kneaddata/mice_ref -db /projects/academic/pidiazmo/projectsoftwares/kneaddata/mice_ref -db /projects/academic/pidiazmo/projectsoftwares/kneaddata/SILVA_ref --output kneaddata_output -t 12 --trimmomatic /projects/academic/pidiazmo/projectsoftwares/kneaddata/kneaddata/share/trimmomatic-0.39-2 --trimmomatic-options SLIDINGWINDOW:4:15

echo 'Succeed.'
echo '--------------------'
