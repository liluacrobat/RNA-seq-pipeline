#!/bin/sh
mkdir pathcoverage
mkdir pathabundance
mkdir genefamilies

for x in *_humann_result; do cp $x/*_pathcoverage.tsv pathcoverage/.
for x in *_humann_result; do cp $x/*_pathabundance.tsv pathabundance/.
for x in *_humann_result; do cp $x/*_genefamilies.tsv genefamilies/.
