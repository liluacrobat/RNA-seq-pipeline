# RNA-seq-pipeline
## ENCODE RNA-seq pipeline
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

testrun_metadata.json is output.

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
## Metagenomic Analysis Using HUMAnN
```
mkdir mapping_list
for x in $(ls *_aln-mapped_sorted.bam);do samtools view $x | awk -F'\t' '{ print $1 "\t" $3 }' > mapping_list/$x.txt; done
```
Reduce size
```
for x in $(ls *merged_sample_diamond_aligned.tsv);do cat $x | awk -F'\t' '{ print $1 "\t" $2 "\t" $3 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 }' > mapping_list/$x.txt; done
```
## Regroup table
```
eval "$(/util/common/python/py38/anaconda-2020.07/bin/conda shell.bash hook)"
conda activate /projects/academic/pidiazmo/projectsoftwares/metaphlan3

mkdir regrouping
cp genefamily_cov50.txt regrouping/genefamily.txt
cd regrouping
humann_regroup_table -i genefamily.txt -o genefamilies_GO.txt -g uniref90_go
humann_regroup_table -i genefamily.txt -o genefamilies_KO.txt -g uniref90_ko
humann_regroup_table -i genefamily.txt -o genefamilies_level4ec.txt -g uniref90_level4ec
humann_regroup_table -i genefamily.txt -o genefamilies_MetaCyCreaction.txt -g uniref90_rxn
humann_regroup_table -i genefamilies_level4ec.txt -o genefamilies_KEGGpwy_by_ec.txt -c ec_to_pwy_renamed.txt
humann_regroup_table -i genefamilies_KO.txt -o genefamilies_KEGGpwy_by_ko.txt -c keggc.txt

humann_rename_table --i genefamilies_GO.txt -n go -o genefamilies_GO_w_anno.txt
humann_rename_table --i genefamilies_KO.txt -n kegg-orthology -o genefamilies_KO_w_anno.txt
humann_rename_table --i genefamilies_level4ec.txt -n ec -o genefamilies_level4ec_w_anno.txt
humann_rename_table --i genefamilies_MetaCyCreaction.txt -n metacyc-rxn -o genefamilies_MetaCyCreaction_w_anno.txt
humann_rename_table --i genefamily.txt -n uniref90 -o genefamilies_UniRef90_w_anno.txt

humann_rename_table --i genefamilies_KEGGpwy_by_ko.txt -c pwy_hierarchy_renamed.txt -o genefamilies_KEGGpwy_by_ko_w_anno.txt
humann_rename_table --i genefamilies_KEGGpwy_by_ec.txt -c pwy_hierarchy_renamed.txt -o genefamilies_KEGGpwy_by_ec_w_anno.txt

```
Collect humann mapping files
```
mkdir diamond_r
mkdir bowtie2_r
xx=/panfs/panfs.cbls.ccr.buffalo.edu/scratch/grp-sunstar/lu/RNA_monster_06_23_2022/RNA/MM_used/sh
for f in *_humann_result;
    do cd $f;
        for x in *_humann_temp;
            do mv $x/*_diamond_aligned.tsv ../diamond_r/. | mv $x/*_bowtie2_aligned.tsv ../bowtie2_r/.;
            done;
        cd $xx
    done
```
