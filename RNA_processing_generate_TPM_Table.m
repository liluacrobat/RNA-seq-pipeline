function RNA_processing_generate_TPM_Table
clc;clear;close all
rsdir = 'resm_gene';
outdir = 'resm_TPM';
ref = 'mm10_M21_rsem_anno.txt';
ref_tbl = readtable(ref,'delimiter','\t');
ref_id = table2array(ref_tbl(:,1));
ref_anno = table2array(ref_tbl(:,4));
listing = dir(rsdir);
n = 0;
for i=1:length(listing)
    if ~(strcmp(listing(i).name,'.')==1||strcmp(listing(i).name,'..')==1)
        n = n+1;
        disp(strcat('File ',num2str(n)));
        Sample_ID{n} = strrep(listing(i).name,'_PE_stranded_anno_rsem.genes.results','');
        [gene_ls{n},gene_length{n},TMP_ls{n}] = loadRESM(strcat(rsdir,'/',listing(i).name));
    end
end
gebe_tmp = gene_ls{1};
for i=2:n
    tmp = gene_ls{i};
    if length(tmp)~=length(gebe_tmp)
        keyboard
    else
        for j=1:length(tmp)
            if strcmp(gebe_tmp{j},tmp{j})~=1
                keyboard
            end
        end
    end
end
gene_id = gene_ls{1};

for i=1:length(gene_length)
    length_mtx(:,i) = gene_length{i};
end
gene_length = mean(length_mtx,2);

ref_idx = AlignID(gene_id,ref_id);
tb_sel = ref_idx~=0;
gene_id_final = gene_id(tb_sel);
gene_length_final = gene_length(tb_sel);
gene_anno_final = ref_anno(ref_idx(ref_idx~=0));

d = length(gene_id_final);
TMP = zeros(d,n);

for i=1:n
    tmp = TMP_ls{i};
    TMP(:,i) = tmp(tb_sel,:);
end
writeResultTable(outdir,gene_id_final,Sample_ID,TMP,gene_anno_final,gene_length_final);
disp('Done');
save mergeTable_done_data
end
function [gene_id,gene_length,TMP] = loadRESM(D)
fid = fopen(D,'r');
n = 0;
line = fgets(fid);
while ~feof(fid)
    n = n+1;
    line = fgets(fid);
    s = strsplit(line,'\t');
    gene_id{n,1} = s{1};
    TMP(n,1) = str2num(s{6});
    gene_length(n,1) = str2num(s{3});
end
end
function idx12=AlignID(ID1,ID2)
% 2->1
n1=length(ID1);
n2=length(ID2);
[~,idx12] = ismember(ID1,ID2);
end
function writeResultTable(map_name,OTU_ID,Sample_ID,Data,tax,GLength)
fid=fopen([map_name '.txt'],'w');
fprintf(fid,'Gene ID');
for i=1:length(Sample_ID)
    fprintf(fid,'\t%s',Sample_ID{i});
end
fprintf(fid,'\tGene Name');
fprintf(fid,'\tGene Length');

fprintf(fid,'\n');
for i=1:length(OTU_ID)
    fprintf(fid,'%s',OTU_ID{i});
    for j=1:length(Sample_ID)
        fprintf(fid,'\t%f',Data(i,j));
    end
    
    fprintf(fid,'\t%s',tax{i});
    fprintf(fid,'\t%f',GLength(i));
    fprintf(fid,'\n');
end
end