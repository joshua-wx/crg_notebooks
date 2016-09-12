function convert_dailyVOL_to_rapic_2
%Joshua Soderholm, June 2016
%Climate Research Group, University of Queensland

%WHAT: Breaks concat'ed rapic volumes (ascii) into individual volumes.

%set input path
in_path = '/home/meso/Downloads/nick_20131017/daily_VOLS/54/';
if exist(in_path)~=7
    display('in_path does not exist, halting')
end

%set odim path
out_path  = '/home/meso/Downloads/nick_20131017/54_rapic/';
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
    fid1      = fopen(input_ffn,'r');
    %setup loop vars
    tline     = fgets(fid1);
    file_idx  = 1;
    %loop through file
    while ischar(tline)
        %if tline is end image line, move text dump into file and clear
        if strcmp(tline(1:7),'COUNTRY')
            %check for error messages and remove
%             k = strfind(rapic_tmp,'MSSG: 30 Status information following - 3D-Rapic TxDevice');
%             if ~isempty(k)
%                rapic_tmp(k:k+57)=[];
%             end
            %replace end line characters
            

            %read parts **NEEDS TO BE HARDENED USING AN ADAPTIVE APPROACH
            k = strfind(tline, 'STNID');
            r_id   = tline(k(1)+7:k(1)+8);
            k = strfind(tline, 'TIMESTAMP');
            dt_num = datenum(tline(k(1)+11:k(1)+24),'yyyymmddHHMMSS');
            %open output file   
            out_ffn = [out_path,r_id,'_',datestr(dt_num,'yyyymmdd'),'_',datestr(dt_num,'HHMMSS'),'.rapic'];
            %cmd = ['head -n ',num2str(file_idx),' ',input_ffn,' | sed ''s/MSSG: 30 Status information following - 3D-Rapic TxDevice//g''  | tail -n 1 > ',out_ffn];
            f_idx_s = num2str(file_idx);
            cmd = ['sed -n ''',f_idx_s,',',f_idx_s,'p'' ',input_ffn,' | sed ''s/MSSG: 30 Status information following - 3D-Rapic TxDevice//g''  | tail -n 1 > ',out_ffn];
            [sout,eout] = unix(cmd);
            
%             fid2=fopen(out_ffn,'w');
%             %write to file
%             fprintf(fid2,'%s',rapic_tmp);
%             %close
%             fclose(fid2);
        end
        tline    = fgets(fid1);
        file_idx = file_idx+1;
    end
end
    