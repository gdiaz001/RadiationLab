filename = 'Radioactive_Lab1.tsv';
DataStartLine = 12; 
opts = detectImportOptions(filename,"FileType","text",'Delimiter','\t');
%t = readtable(filename,"FileType","text",'Delimiter','\t');
opts.SelectedVariableNames = ["Run","High","Var3","Elapsed"];
T = readtable(filename,opts);
T = renamevars(T,["Run","High","Var3","Elapsed"],...
                 ["Run Number","High Voltage","Counts","Elapsed Time"]);

A = table2array(T);
scatter(T,"High Voltage","Counts","filled"); 
grid on 
title("Counts vs Voltage");
xlabel('High Voltage (Volts)');
ylabel('Counts'); 

x = table2array(T(:,"High Voltage"));
y = table2array(T(:,"Counts"));

slopes = zeros(length(x)-1,1);
for i = 1:length(x)-1
    slopes(i) = 100*(y(i+1)-y(i))/(x(i+1)-x(i))/y(i);
end
