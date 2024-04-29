sr90_filename = "Radioactive_lab6_sr90.tsv"; 

opts = detectImportOptions(sr90_filename,"FileType","text",'Delimiter','\t','Range',11);
opts.SelectedVariableNames = ["Number","Voltage","Counts","Time"];

sr90_table = readtable(sr90_filename,opts);

dead_time = 100; %microseconds
% background counts per minute
background_cpm = 2 * 22; 
    %correcting for dead time
    background_cpm = background_cpm/(1-background_cpm*dead_time/60/10^6);
%

%counts per minute
sr90_cpm = 2 * table2array(sr90_table(:,"Counts")); 

%sr90 
% correcting for dead time according to formula R = r / (1-rT) 
%T = dead_time (must convert to minutes) 
sr90_cpm_corrected = zeros(length(sr90_cpm),1);
for i = 1:length(sr90_cpm) 
    r = sr90_cpm(i);
    denom = 1 - r*dead_time/60/10^6; 
    x = r/denom; 
    sr90_cpm_corrected(i) = x; 
end

%correcting for background
sr90_cpm_corrected = sr90_cpm_corrected - background_cpm; 

sr90_shelf_ratios = zeros(length(sr90_cpm),1);
for i = 1:length(sr90_cpm)
    sr90_shelf_ratios(i) = sr90_cpm_corrected(i)/sr90_cpm_corrected(2); %shelf 2 is the reference
end



shelf = 1:length(sr90_cpm);
shelf = shelf';
t = table(shelf,sr90_cpm_corrected,sr90_shelf_ratios);
t = renamevars(t,["shelf" "sr90_cpm_corrected" "sr90_shelf_ratios"],["Shelf #" "Corrected Counts" "Ratio"]);

plot(shelf,sr90_shelf_ratios)