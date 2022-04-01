# RNA-seq-pipeline

```
#!/bin/sh
#SBATCH --partition=general-compute
#SBATCH --time=71:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --job-name="ENCODE-RNA"
#SBATCH --output=ENCODE-RNA.log

module load qiime2
conda activate /projects/academic/pidiazmo/projectsoftwares/encode/rna-seq

```
python=3.8
conda install star
conda install cutadapt
