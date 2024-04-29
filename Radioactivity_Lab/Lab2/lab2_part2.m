%for part 2, cs 137

part2_filename = "Radioactive_Lab2_part2.tsv";
DataStartLine = 12;
opts = detectImportOptions(part2_filename,"FileType","text",'Delimiter','\t');
opts.SelectedVariableNames = ["Run","High","Var3","Elapsed"];
T2 = readtable(part2_filename,opts);
T2 = renamevars(T2,["Run","High","Var3","Elapsed"],...
                 ["Run Number","High Voltage","Counts","Elapsed Time"]);
Mean = table2array(mean(T2(:,"Counts"))); %from 1x1 table to 1x1 array == double 
Minimum = table2array( min(T2(:,"Counts"))); 
Maximum = table2array(max(T2(:,"Counts"))); 
StdDev = table2array(std(T2(:,"Counts"))); 

data_counts = table2array(T2(:,"Counts"));
g_22 = sqrt(Mean); 
h_arr = Minimum:1:Maximum;

freq = zeros(length(h_arr),1);
for i = 1:length(h_arr)
    freq(i) = sum(data_counts==h_arr(i));
end

poisson_pdf = zeros(length(h_arr),1);

%
for i = 1:length(h_arr)
    x = sym(Mean)^h_arr(1,i);
    x = x / factorial(sym(h_arr(1,i))); 
    x = x * exp(-sym(Mean))*750; 
    poisson_pdf(i) = x ; 
end 

gauss_pdf = zeros(length(h_arr),1);
for i = 1:length(h_arr)
    x = h_arr(1,i); 
    f = exp(-0.5*power( (x-Mean)/StdDev,2 ));
    f = f / StdDev / sqrt(2*pi); 
    f = f*750;
    gauss_pdf(i) = f; 
end
 
plot(h_arr,poisson_pdf,"blue",h_arr,gauss_pdf,"red");
hold on 
scatter(h_arr,freq,"filled","black"); 
title("Statistics of counting")
xlabel("Counts")
ylabel("Frequency")
hold off 
legend()
ylim([0 90])


[muhat,sigmahat] = normfit(h_arr);
lambdahat = poissfit(h_arr);

disp([Mean muhat lambdahat]);
% curveFitter(h_arr,freq);

disp(StdDev);