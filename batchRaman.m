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
[rawColumns numSpec] = size(data);
fprintf('Number of Spectra: %i \n', numSpec);
namesSpec = get(data, 'VarNames')';

workingSpec=struct();


for i=1:numSpec
    workingSpec.(char(namesSpec(i))).x = data.(char(namesSpec(i)))(:,1);
    workingSpec.(char(namesSpec(i))).y = data.(char(namesSpec(i)))(:,2);
end

%%
% % Fit G+ Peak and Normalize Data
% 
% for i=1:numSpec
%     x = workingSpec.(char(namesSpec(i))).x;
%     y = workingSpec.(char(namesSpec(i))).y;
% 
%     % Apply exclusion rule "Isolating G-Band"
%     if length(x)~=1600
%         error('Exclusion rule ''%s'' is incompatible with ''%s''.','Isolating G-Band','x');
%     end
%     ex_ = true(length(x),1);
%     ex_([(606:718)]) = 0;
%     ok_ = isfinite(x) & isfinite(y);
%     if ~all( ok_ )
%         warning( 'GenerateMFile:IgnoringNansAndInfs', ...
%             'Ignoring NaNs and Infs in data' );
%     end
%     st_ = [10000 10000 40 40 1565 1595 881 ];
%     ft_ = fittype('y0+(2*a1/pi)*(w1/(4*(x-xc1)^2+w1^2))+(2*a2/pi)*(w2/(4*(x-xc2)^2+w2^2))',...
%         'dependent',{'y'},'independent',{'x'},...
%         'coefficients',{'a1', 'a2', 'w1', 'w2', 'xc1', 'xc2', 'y0'});
% 
%     % Fit this model using new data
%     if sum(~ex_(ok_))<2  %% too many points excluded
%         error('Not enough data left to fit ''%s'' after applying exclusion rule ''%s''.','G-Band','Isolating G-Band')
%     else
%         cf(i).GBand = fit(x(ok_),y(ok_),ft_,'Startpoint',st_,'Exclude',ex_(ok_));
%     end
% 
%     % Or use coefficients from the original fit:
%     if 0
%         cv_ = { 75724.418393143161666, 79497.321919432826689, 22.141589731970249488, 49.620463671144626971, 1596.0119990189443797, 1576.5888401848656031, 835.8907996299418528};
%         cf(i).GBand = cfit(ft_,cv_{:});
%     end
%     
%     workingSpec.(char(namesSpec(i))).y = (workingSpec.(char(namesSpec(i))).y)./feval(cf(i).GBand,max(cf(i).GBand.xc1,cf(i).GBand.xc2));
%     
% end


%%
% New Dataset for Fitting Results
x =[];
PeakSet = dataset;

clf;

%subplot(ceil(numSpec/2),2,1)

%Start Coding for FIT and Plot
if lambda == 532
    for i=1:numSpec

        % Set up figure to receive datasets and fits
        x = ramanFit532(workingSpec.(char(namesSpec(i))).x,workingSpec.(char(namesSpec(i))).y,namesSpec(i),i);
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
    
    
