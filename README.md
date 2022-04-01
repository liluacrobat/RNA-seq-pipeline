# RNA-seq-pipeline

```
#!/bin/sh
#SBATCH --partition=general-compute
#SBATCH --time=71:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=30000
#SBATCH --job-name="ENCODE-RNA"
#SBATCH --output=ENCODE-RNA.log
#SBATCH --mail-user=lli59@buffalo.edu
#SBATCH --mail-type=ALL

module load qiime2
conda activate /projects/academic/pidiazmo/projectsoftwares/encode/rna-seq

caper run rna-seq-pipeline.wdl -m testrun_metadata.json -i PE_stranded_input.json -b local --singularity

```
python=3.8
conda install star
conda install cutadapt
