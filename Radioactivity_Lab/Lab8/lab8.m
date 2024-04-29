sr90_filename = "Radioactive_lab8_sr90.tsv"; 
opts = detectImportOptions(sr90_filename,"FileType","text",'Delimiter','\t','Range',11);
opts.SelectedVariableNames = ["Number","Voltage","Counts","Time"];
sr90_table = readtable(sr90_filename,opts);
dead_time = 100; %microseconds

% background counts per minute
background_cpm = 2 * 34; 
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


%distances 
distances = 2:1+length(sr90_cpm_corrected); % in cm
    %converting to meters
    distances = distances / 100; 

one_over_d_sqaure = zeros(length(distances),1);
for i = 1:length(distances)
    one_over_d_sqaure(i) = 1 /distances(i)/distances(i); 
end


a=polyfit(one_over_d_sqaure,sr90_cpm_corrected,1);
cc_matrix = corrcoef(one_over_d_sqaure,sr90_cpm_corrected);
R_squared = (cc_matrix(1,2))^2;
lm = fitlm(one_over_d_sqaure,sr90_cpm_corrected);
std_error = diag(sqrt(lm.CoefficientCovariance));
std_error = std_error(1);
scatter(one_over_d_sqaure,sr90_cpm_corrected,"filled","black"); 
hold on 
grid on 
plot(one_over_d_sqaure,polyval(a,one_over_d_sqaure));
title("Counts vs 1/d^2")
xlabel("1/d^2 (1/meters^2)")
ylabel("Counts")
hold off 
%curveFitter(one_over_d_sqaure,sr90_cpm_corrected);