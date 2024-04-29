%for part 1, no source 

part1_filename = "Radioactive_Lab2_part1.tsv";
DataStartLine = 12;
opts = detectImportOptions(part1_filename,"FileType","text",'Delimiter','\t');
opts.SelectedVariableNames = ["Run","High","Var3","Elapsed"];
T1 = readtable(part1_filename,opts);
T1 = renamevars(T1,["Run","High","Var3","Elapsed"],...
                 ["Run Number","High Voltage","Counts","Elapsed Time"]);
Mean = table2array(mean(T1(:,"Counts"))); %from 1x1 table to 1x1 array == double 
Minimum = table2array( min(T1(:,"Counts"))); 
Maximum = table2array(max(T1(:,"Counts"))); 
StdDev = table2array(std(T1(:,"Counts"))); 

data_counts = table2array(T1(:,"Counts"));
g_22 = sqrt(Mean); 
h_arr = Minimum:1:Maximum;

%
freq = zeros(length(h_arr),1);
for i = 1:length(h_arr)
    freq(i) = sum(data_counts==h_arr(i));
end


poisson_pdf = zeros(length(h_arr),1);

%
for i = 1:length(h_arr)
    x = power(Mean,h_arr(1,i));
    x = x / factorial(h_arr(1,i)); 
    x = x * exp(-Mean)*150; 
    poisson_pdf(i) = x ; 
end 

gauss_pdf = zeros(length(h_arr),1);
for i = 1:length(h_arr)
    x = h_arr(1,i); 
    f = exp(-0.5*power( (x-Mean)/StdDev,2 ));
    f = f / StdDev / sqrt(2*pi); 
    f = f*150;
    gauss_pdf(i) = f; 
end

plot(h_arr,poisson_pdf,"blue",h_arr,gauss_pdf,"red");
hold on 
scatter(h_arr,freq,"filled","black"); 
title("Statistics of counting")
xlabel("Counts")
ylabel("Frequency")
hold off 
legend("poisson","gauss","data")
xlim([0 40])
grid on

[muhat,sigmahat] = normfit(h_arr);
lambdahat = poissfit(h_arr);