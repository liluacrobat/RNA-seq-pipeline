function genRSEMmapping_RSEM
clc;clear;close all;
idxfile = 'rsem.ti';
output = 'mm10_M21_rsem';
type = '_anno';

% rtbl = readtable
fid = fopen(idxfile,'r');
ofid = fopen(strcat(output,'_',type,'.txt'),'w');
fprintf(ofid,'gene id\ttranscript_id\tgene_type\tgene_name\ttranscript_type\ttranscript_name\tlevel\n');
n=0;
ii=0;
while ~feof(fid)
    line = fgets(fid);
    ii=ii+1;
    disp(ii);
    if startsWith(line,'gene_id')
        s = strsplit(line,';');
        
        n = n+1;
        if mod(n,1000)==0
            disp(['n: ' num2str(n)])
        end
        gene_id{n} = '';
        gene_type{n} = '';
        gene_name{n} = '';
        transcript_id{n} = '';
        transcript_type{n} = '';
        transcript_name{n} = '';
        level{n} = '';
        s2 = s;
        for i=1:length(s2)
            s2{i} = strtrim(s2{i});
            if startsWith(s2{i},'gene_id')
                gene_id{n} = strtrim(strrep(strrep(s2{i},'"',''),'gene_id',''));
            else
                if startsWith(s2{i},'transcript_id')
                    transcript_id{n} = strtrim(strrep(strrep(s2{i},'"',''),'transcript_id',''));
                else
                    if startsWith(s2{i},'gene_type')
                        gene_type{n} = strtrim(strrep(strrep(s2{i},'"',''),'gene_type',''));
                    else
                        if startsWith(s2{i},'gene_name')
                            gene_name{n} = strtrim(strrep(strrep(s2{i},'"',''),'gene_name',''));
                        else
                            if startsWith(s2{i},'transcript_type')
                                transcript_type{n} = strtrim(strrep(strrep(s2{i},'"',''),'transcript_type',''));
                            else
                                if startsWith(s2{i},'transcript_name')
                                    transcript_name{n} = strtrim(strrep(strrep(s2{i},'"',''),'transcript_name',''));
                                else
                                    if startsWith(s2{i},'level')
                                        level{n} = strtrim(s2{i});
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
        end
        fprintf(ofid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\n',gene_id{n},transcript_id{n},gene_type{n},gene_name{n},transcript_type{n},transcript_name{n},level{n});
%         disp(n);
    else
        disp(line);
        %         keyboard
    end
end
end
