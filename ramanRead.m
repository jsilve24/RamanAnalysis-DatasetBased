function [parseddata] = ramanRead(filenames,varnames)
% ramanRead(filenames,varnames) : both inputs can be cell arrays
%
% Reads in data starting after '#Data' and 
% outputs to a dataset parseddata 

if size(filenames)~=size(varnames)
    disp('input dimentions do not match');
end

parseddata = dataset;

for i = 1:size(filenames)
    fid = fopen(char(filenames(i)),'r');
    
    % reads line one by one into a cell
    a = 1;
    line = 0;
    while line ~= -1
        line = fgets(fid);
        data{a}=line; 
        a = a + 1;
    end
    fclose(fid);
    
    % This loop determines where numerical data starts
    for p = 1:length(data)
        if strncmp(data{p},'#DATA',5)
            break;
        end
    end
    
    % This loop saves the numerical data into parseddata
    % until the numerical data stops
    for x = p+1:length(data)-1 %Only Numerical Values 
        temp(x-p,:) = sscanf(data{x},'%f')';
    end
    tempdataset = ramandataset({temp,char(varnames(i,:))});
    parseddata.(char(varnames(i,:))) = tempdataset.(char(varnames(i,:)));
end
    


%  help textread
%  exit debugger with dbquit
