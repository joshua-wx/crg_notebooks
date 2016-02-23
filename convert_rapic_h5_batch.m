function covert_rapic_h5_batch
%WHAT: Batch script for rapid_odim in matlab. Needs to be converted to
%bash. Does not support subdirectories. Requires rapic_to_odim utility
%installed

%set path
rapic_path = '/home/meso/nick_data/20160214Melb/';
if exist(rapic_path)~=7
    display('rapic_path does not exist, halting')
end

%set odim dir
odim_path  = '/home/meso/nick_data/20160214Melb_odim/';
if exist(odim_path)~=7
    display('odim_path does not exist, halting')
end

%get listing
path_listing = dir(rapic_path);

%loop through even file in path
for i = 1:length(path_listing)
    
    %set input_ffn
    input_ffn = [rapic_path,path_listing(i).name];
    
    [~, fn, fn_ext] = fileparts(input_ffn);
    
    %check if we are processing a rapic file
    if ~strcmp(fn_ext,'.rapic')
        display([input_ffn,' is not a rapic file, skipping']);
        continue
    end
    
    %set output_ffn
    output_ffn = [odim_path,fn,'.h5'];
    
    %push through rapic_to_odim
    display(['Processing file ',num2str(i),' of ',num2str(length(path_listing)),' ',input_ffn]);
    [~,~] = unix(['export LD_LIBRARY_PATH=/usr/lib; rapic_to_odim ',input_ffn,' ',output_ffn]); %note, reset lD path from matlab to system default
end
