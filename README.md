# RNA-seq-pipeline
https://data.4dnucleome.org/resources/data-analysis/rnaseq-processing-pipeline

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

## Collect results
```
mkdir resm_result
for x in rep*;do cp $x/*.results resm_result/.;done
```
```
mkdir kallisto_result
for x in rep*;do cp $x/*.tsv kallisto_result/.;done
```
## Gene list
Check gene http://angiogenes.uni-frankfurt.de/gene/ENSMUSG00000105951
# Microbiome RNA-seq
## Kneaddata filtering
```
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
kneaddata --input ../__SAMPLE_ID___R1.fastq --input ../__SAMPLE_ID___R2.fastq -db /projects/academic/pidiazmo/projectsoftwares/kneaddata/hg37_ref -db /projects/academic/pidiazmo/projectsoftwares/kneaddata/mice_ref -db /projects/academic/pidiazmo/projectsoftwares/kneaddata/mice_ref  /projects/academic/pidiazmo/projectsoftwares/kneaddata/SILVA_ref --output kneaddata_output -t 12 --trimmomatic /projects/academic/pidiazmo/projectsoftwares/kneaddata/kneaddata/bin/trimmomatic

echo 'Succeed'
echo '--------------------'

```
