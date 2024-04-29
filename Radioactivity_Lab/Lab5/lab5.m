base_path = "Radioactive_lab5_";
co60_filename = base_path + "co60.tsv";
co60_nosrc_filename = base_path +"co60background.tsv";
po210_filename = base_path + "po210.tsv";
po210_nosrc_filename = base_path+"po210background.tsv";
sr90_filename = base_path + "sr90.tsv";
sr90_nosrc_filename = base_path + "sr90background.tsv"; 

opts = detectImportOptions(co60_filename,"FileType","text",'Delimiter','\t','Range',11);
opts.SelectedVariableNames = ["Number","Voltage","Counts","Time"];

% 
K = 2.22 * 10^6; % units: dpm / uCi 
activity_po210 = 0.1; % in uCi 
activity_co60 = 1.0; %in uCi 

dead_time = 100; %in micro seconds 

background_count = 40; 

% co60,po210,sr90 
%counts in counts per minute(cpm) 
radiation_counts = [761;54;9641]; %note: probably an error in measurements 
activity = [activity_co60;activity_po210;activity_po210]; 

%applying dead time correction to radiation_counts
% correcting for dead time according to formula R = r / (1-rT) 
%T = dead_time (must convert to minutes) 
for element = 1:length(radiation_counts)
    r = radiation_counts(element);
    radiation_counts(element) = r/(1-r*dead_time/60/10^6);
end

% applying background correction  
radiation_counts = radiation_counts - background_count; 

percent_eff = zeros(length(radiation_counts),1);

for element = 1:length(percent_eff)
    percent_eff(element) = radiation_counts(element)*100/activity(element)/K; 
end

disp(percent_eff); 

sources = ["Co-60" ; "Po-210" ; "Sr-90"]; 
activity = activity * K; 

t = table(sources,activity, radiation_counts,percent_eff);

t = renamevars(t,["sources" "activity" "radiation_counts" "percent_eff"],["Radioactive Source" "Expected cpm" "Corrected cpm" "% Efficiency"]);


