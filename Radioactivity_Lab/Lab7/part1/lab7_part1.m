%part 1 
background_cpm = 44; 

no_absorber_cpm = 9777; 

dead_time = 100; %in microseconds

%atomic numbers
    %A,B,G - P Aluminum Z = 13
    %C - F Platic/polycarbonate Carbon Z = 6
    %Q - T Lead Z = 82 
ALUMINUM = 6;
CARBON = 13;
LEAD = 82; 
 

myFolder = "/Users/gabrieldiaz/Documents/MATLAB/Radioactivity_Lab/Lab7/part1"; 

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

disp(backscattering); 

atomic_numbers = zeros(length(corrected_absorber_cpm),1);
atomic_numbers(1) = ALUMINUM;
atomic_numbers(2) = atomic_numbers(1); 

for k = 7:16
    atomic_numbers(k) = ALUMINUM;
end
for k = 3:6
    atomic_numbers(k) = CARBON;
end
for k = 17:20
    atomic_numbers(k) = LEAD;
end

disp(atomic_numbers); 

scatter(corrected_absorber_cpm,atomic_numbers); 
