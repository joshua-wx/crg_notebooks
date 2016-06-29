function convert_dailyVOL_to_rapic
%Joshua Soderholm, June 2016
%Climate Research Group, University of Queensland

%WHAT: Breaks concat'ed rapic volumes (ascii) into individual volumes.

%set input path
in_path = '/home/meso/Desktop/testing/in/';
if exist(in_path)~=7
    display('in_path does not exist, halting')
end

%set odim path
out_path  = '/home/meso/Desktop/testing/out/';
if exist(out_path)~=7
    display('out_path does not exist, halting')
end

%get listing
path_listing = dir(in_path);

dbstop if warning

%loop through even file in path
for i = 1:length(path_listing)
    
    %set input_ffn
    input_ffn = [in_path,path_listing(i).name];
    
    %check if we are processing a rapic file
    [~, fn, fn_ext] = fileparts(input_ffn);
    if ~strcmp(fn_ext,'.VOL')
        display([input_ffn,' is not a VOL file, skipping']);
        continue
    end
    %open input file
    fid1      = fopen(input_ffn);
    %setup loop vars
    rapic_tmp = '';
    tline     = fgets(fid1);
    %loop through file
    while ischar(tline)
        %append to temp text
        rapic_tmp = [rapic_tmp,tline];
        %if tline is end image line, move text dump into file and clear
        if strcmp(tline(1:9),'/IMAGEEND')
            %read parts **NEEDS TO BE HARDENED USING AN ADAPTIVE APPROACH
            k = strfind(rapic_tmp, 'STNID');
            r_id   = rapic_tmp(k(1)+7:k(1)+8);
            k = strfind(rapic_tmp, 'TIMESTAMP');
            dt_num = datenum(rapic_tmp(k(1)+11:k(1)+24),'yyyymmddHHMMSS');
            %open output file
            out_ffn = [out_path,r_id,'_',datestr(dt_num,'yyyymmdd'),'_',datestr(dt_num,'HHMMSS'),'.pvol.rapic'];
            fid2=fopen(out_ffn,'w');
            %write to file
            fprintf(fid2,'%s',rapic_tmp);
            %close
            fclose(fid2);
            %clear text data
            rapic_tmp = '';
        end
        tline = fgets(fid1);
    end
    %warn if it did not exit cleanly
    if ~isempty(rapic_tmp)
        display('warning, rapic_tmp not empty')
    end
end
    