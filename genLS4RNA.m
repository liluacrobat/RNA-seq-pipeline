function genLS4RNA
clc;clear;close all
filename = 'fastq_list.txt';
pathdir = '../fastq/';
tailfix = '_001.fastq.gz';
tailfix1 = strcat('R1',tailfix);
tailfix2 = strcat('R2',tailfix);
fid = fopen(filename,'r');
n = 0;
while ~feof(fid)
    line = fgetl(fid);
    if endsWith(line, tailfix1) 
        n = n+1;
    end
end

filename1 = 'R1_list4templete.txt';
filename2 = 'R2_list4templete.txt';

fid = fopen(filename,'r');
fid1 = fopen(filename1,'w');
fid2 = fopen(filename2,'w');
i = 0;
while ~feof(fid)
    line = fgetl(fid);
    if endsWith(line, tailfix1) 
        i = i+1;
        if i~=n
        fprintf(fid1,'[\"%s%s\"],\n',pathdir,line);
        fprintf(fid2,'[\"%s%s\"],\n',pathdir,strrep(line,tailfix1,tailfix2));
        else
           fprintf(fid1,'[\"%s%s\"]\n',pathdir,line); 
           fprintf(fid2,'[\"%s%s\"]\n',pathdir,strrep(line,tailfix1,tailfix2));
        end
    end
end
end