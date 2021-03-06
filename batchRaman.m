function [FitSet] = batchRaman(spec,lambda) 
% Batch Analysis of Raman Data, input argument is Dataset
% Save all data as a Dataset with format:
% *******************
% SMPL7Dried       SMPL8Dried
% 2.6322  16377    2.6322  1664
% cm^-1   RamanIn  cm^-1   RamanInt
% *******************
%   x = cm^-1
%   y = Raman Intensity

%%
global numSpec;

% Display general data
data = spec;
get(data);

% Split data into usable pieces
numSpec = size(data,2);
fprintf('Number of Spectra: %i \n', numSpec);
namesSpec = get(data, 'VarNames')';

workingSpec=struct();


for i=1:numSpec
    workingSpec.(char(namesSpec(i))).x = data.(char(namesSpec(i)))(:,1);
    workingSpec.(char(namesSpec(i))).y = data.(char(namesSpec(i)))(:,2);
end
%%
%Adjust wavenumbers scale for drift in detector by fitting Si Peak
for i = 1:numSpec
    [workingSpec.(char(namesSpec(i))).x, workingSpec.(char(namesSpec(i))).x] =...
        correctToSiPeak(workingSpec.(char(namesSpec(i))).x, workingSpec.(char(namesSpec(i))).x);
end %End For

%%
% New Dataset for Fitting Results
x =[];
PeakSet = dataset;

clf;

%subplot(ceil(numSpec/2),2,1)

%Start Coding for FIT and Plot
if lambda == 514
    for i=1:numSpec

        % Set up figure to receive datasets and fits
        x = ramanFit514(workingSpec.(char(namesSpec(i))).x,workingSpec.(char(namesSpec(i))).y,namesSpec(i),i);
        FitSet.(char(namesSpec(i))) = x;
    end
elseif lambda == 1064
    for i=1:numSpec

        % Set up figure to receive datasets and fits
        x = ramanFit1064(workingSpec.(char(namesSpec(i))).x,workingSpec.(char(namesSpec(i))).y,namesSpec(i),i);
        FitSet.(char(namesSpec(i))) = x;
    end
else 
    disp('Specified Excitation Wavelength not Currently Coded');
    
end

for i=1:numSpec
    % Record D and G Peaks
    DPeak = feval(FitSet.(char(namesSpec(i))).DBand, FitSet.(char(namesSpec(i))).DBand.xc);
    GPlusPeak = feval(FitSet.(char(namesSpec(i))).GBand, max(FitSet.(char(namesSpec(i))).GBand.xc1,FitSet.(char(namesSpec(i))).GBand.xc2));
    GMinusPeak = feval(FitSet.(char(namesSpec(i))).GBand, min(FitSet.(char(namesSpec(i))).GBand.xc1,FitSet.(char(namesSpec(i))).GBand.xc2));
    
    y = dataset({DPeak,'DPeak'},{GPlusPeak,'GPlusPeak'},{GMinusPeak,'GMinusPeak'},'ObsNames',char(namesSpec(i)));
    PeakSet = [PeakSet;y];
    
end

%%
% Compute Relavant Length Dependent Parameters


% Parameters to Compute: 
%   I_D/I_G+
%   
%   
%   


% I_D/I_G+

for i=1:numSpec
  DtG(i) = PeakSet.DPeak(i)/PeakSet.GPlusPeak(i);
end
y = dataset({DtG','DtG_Ratio'},'ObsNames',namesSpec);
PeakSet = [PeakSet y];


% Write PeakSet into FitSet before exit
FitSet.PeakSet = PeakSet;
    
    
