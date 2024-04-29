%part2 
%source: sr90
%absorbing material: Aluminum 

background_cpm = 45;
no_absorber_cpm = 9805; 
dead_time = 100; %microseconds

thickness = [0.025;0.032;0.063;0.090;0.125]; %inches
aerial_thickness = [170;216 ;425; 645; 840]; % mg/cm^2


myFolder = "/Users/gabrieldiaz/Documents/MATLAB/Radioactivity_Lab/Lab7/part2"; 
if ~isfolder(myFolder)
    errorMessage = fprintf('Error: The following folder does not exist:\n%s',myFolder); 
end
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, 'sr90_absorber_*.tsv');
theFiles = dir(filePattern); 

    % get cpm for absorber_* 
absorber_cpm = zeros(length(theFiles),1);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(myFolder,baseFileName);
    opts = detectImportOptions(fullFileName,"FileType","text",'Delimiter','\t','Range',11);
    opts.SelectedVariableNames = ["Number","Voltage","Counts","Time"];
    sr90_table = readtable(fullFileName,opts);
    sr90_cpm = table2array(sr90_table(:,"Counts")); 
    absorber_cpm(k) = sr90_cpm; 
end

%correcting for dead time 
corrected_absorber_cpm = zeros(length(absorber_cpm),1);
for k = 1:length(corrected_absorber_cpm)
    corrected_absorber_cpm(k) = absorber_cpm(k)/(1-absorber_cpm(k)*dead_time/60/10^6);
end
background_cpm = background_cpm/(1-background_cpm*dead_time/60/10^6); %now corrected
no_absorber_cpm = no_absorber_cpm/(1-no_absorber_cpm*dead_time/60/10^6); %now corrected

%correcting for background 
corrected_absorber_cpm = corrected_absorber_cpm - background_cpm; 
no_absorber_cpm = no_absorber_cpm - background_cpm; 

%calculating percent of counts from backscattering 
% percent backscattering = 100 * (r -r0)/r0 
backscattering = zeros(length(corrected_absorber_cpm),1);
for k = 1:length(corrected_absorber_cpm)
    backscattering(k) = 100 * corrected_absorber_cpm(k)/no_absorber_cpm - 100; 
end


figure(1);
a = polyfit(thickness,corrected_absorber_cpm,1);
plot(thickness,corrected_absorber_cpm,'.',thickness,polyval(a,thickness));
grid on
title('Corrected Counts vs Thickness');
xlabel('Thickness (inches)');
ylabel('Corrected counts (per minute)'); 

disp(a);

figure(2);
b = polyfit(aerial_thickness,corrected_absorber_cpm,1);
plot(aerial_thickness,corrected_absorber_cpm,'.',aerial_thickness,polyval(b,aerial_thickness));
grid on
title('Corrected Counts vs Aerial Thickness');
xlabel('Thickness (mg/cm^2)');
ylabel('Corrected counts (per minute)'); 

cc_matrix = corrcoef(aerial_thickness,corrected_absorber_cpm);
R_squared = (cc_matrix(1,2))^2;

backscattering_table = table(thickness, aerial_thickness,backscattering); 
backscattering_table = renamevars(backscattering_table, ["thickness","backscattering"],...
    ["Thickness (in.)","% Backscattering"]);
backscattering_table = renamevars(backscattering_table,"aerial_thickness","Aerial Thickness (mg/cm^2)");
fig = uifigure("Position",[500 500 750 500]);
uit = uitable(fig,"Data",backscattering_table,"Position",[10,10,500,400]);



%%%%%%%%



