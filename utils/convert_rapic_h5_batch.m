function covert_rapic_h5_batch
%Joshua Soderholm, June 2016
%Climate Research Group, University of Queensland

%WHAT: Batch script for rapid_odim in matlab. Needs to be converted to
%bash. Does not support subdirectories. Requires rapic_to_odim utility
%installed

%set path
rapic_path = '/home/meso/Desktop/testing/out/';
if exist(rapic_path)~=7
    display('rapic_path does not exist, halting')
end

%set odim dir
odim_path  = '/home/meso/Desktop/testing/odim_out/';
if exist(odim_path)~=7
    display('odim_path does not exist, halting')
end

%get listing
path_listing = dir(rapic_path);

%loop through even file in path
for i = 1:length(path_listing)

    %set input_ffn
    input_ffn = [rapic_path,path_listing(i).name];

    %check if file contains data
    input_size = path_listing(i).bytes/1000;
    if input_size<20
        display([input_ffn,' is empty, skipping']);
        continue
    end
    
    %check if we are processing a rapic file
    [~, fn, fn_ext] = fileparts(input_ffn);
    if ~strcmp(fn_ext,'.rapic')
        display([input_ffn,' is not a rapic file, skipping']);
        continue
    end

    %set output_ffn
    output_ffn = [odim_path,fn,'.h5'];

    %push through rapic_to_odim
    display(['Processing file ',num2str(i),' of ',num2str(length(path_listing)),' ',input_ffn]);
    [sout,eout] = unix(['export LD_LIBRARY_PATH=/usr/lib; rapic_to_odim ',input_ffn,' ',output_ffn]); %note, reset lD path from matlab to system default
    if sout==1
        display(eout)
        keyboard
    end
        
end
