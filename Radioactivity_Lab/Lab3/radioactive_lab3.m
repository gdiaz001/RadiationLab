nosrc_filename = "Radioactive_lab3_nosrc.tsv";
cs_filename = "Radioactive_lab3_cs.tsv";

DataStartLine = 12;
opts = detectImportOptions(nosrc_filename,"FileType","text",'Delimiter','\t','Range',11);
opts.SelectedVariableNames = ["Number","Voltage","Counts","Time"];


nosrc_table = readtable(nosrc_filename,opts); 
nosrc_table = renamevars(nosrc_table,"Number","Run Number"); 
cs_table = readtable(cs_filename,opts);
cs_table = renamevars(cs_table,"Number","Run Number"); 

average_counts = table2array(mean(cs_table(:,"Counts")));
s_counts = table2array(std(cs_table(:,"Counts")));
average_background = table2array(mean(nosrc_table(:,"Counts")));
s_background = table2array(std(nosrc_table(:,"Counts")));

average_true_counts = average_counts - average_background;  % for 300 secs 
s_true = s_counts - s_background;
disp(average_true_counts); 

background_cpm = average_background/5; %background counts per minute
background_cpd = background_cpm * 60 * 24; %per day
background_cpy = background_cpd * 365.25; %per year 

background_cpm, background_cpd, background_cpy


