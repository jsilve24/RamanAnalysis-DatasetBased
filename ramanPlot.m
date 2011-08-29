function [dataset] = ramanPlot(dataset,arrangement,normalize)
% ramanPlot(dataset,arrangement) plots raman data 
% each spectra given subplot if arrangement = 'subplot'
% all spectra plotted together if arrangement = 'single'
% Will Normalize Spectra if normalize  = 'normalize'

% Save all data as a Dataset with format:
% 
% *******************
% SMPL7Dried       SMPL8Dried
% 2.6322  16377    2.6322  1664
% cm^-1   RamanIn  cm^-1   RamanInt
% *******************

% Does not plot Fits
% Does not Do Any Calculations

[rawColumns numSpec] = size(dataset);
fprintf('Number of Spectra: %i \n', numSpec);
namesSpec = get(dataset, 'VarNames')';

if strcmp('normalize',normalize)
    %Fit G+ Peak and Normalize Data
    for i=1:numSpec
        x = dataset.(char(namesSpec(i)))(:,1);
        y = dataset.(char(namesSpec(i)))(:,2);
% % % %         y = detrend(y);
% % %         % Remove Baseline %%% Need to exclude peaks from detrend
% % %         x = detrend(x);
% % %         xBase = [x(228:341); x(705:1109)];
% % %         yBase = [y(228:341); y(705:1109)];
% % %         polyBase = polyfit(xBase,yBase,1);
% % %         Base = polyval(polyBase,x);
% % %         
% % %         y = y - Base; 

   
    
        % Apply exclusion rule "Isolating G-Band"
        if length(x)~=1600
            error('Exclusion rule ''%s'' is incompatible with ''%s''.','Isolating G-Band','x');
        end
        ex_ = true(length(x),1);
        ex_([(606:718)]) = 0;
        ok_ = isfinite(x) & isfinite(y);
        if ~all( ok_ )
            warning( 'GenerateMFile:IgnoringNansAndInfs', ...
                'Ignoring NaNs and Infs in data' );
        end
        st_ = [10000 10000 40 40 1565 1595 881 ];
        ft_ = fittype('y0+(2*a1/pi)*(w1/(4*(x-xc1)^2+w1^2))+(2*a2/pi)*(w2/(4*(x-xc2)^2+w2^2))',...
            'dependent',{'y'},'independent',{'x'},...
            'coefficients',{'a1', 'a2', 'w1', 'w2', 'xc1', 'xc2', 'y0'});
    
        % Fit this model using new data
        if sum(~ex_(ok_))<2  %% too many points excluded
            error('Not enough data left to fit ''%s'' after applying exclusion rule ''%s''.','G-Band','Isolating G-Band')
        else
            cf(i).GBand = fit(x(ok_),y(ok_),ft_,'Startpoint',st_,'Exclude',ex_(ok_));
        end
    
        % Or use coefficients from the original fit:
        if 0
            cv_ = { 75724.418393143161666, 79497.321919432826689, 22.141589731970249488, 49.620463671144626971, 1596.0119990189443797, 1576.5888401848656031, 835.8907996299418528};
            cf(i).GBand = cfit(ft_,cv_{:});
        end
        
        dataset.(char(namesSpec(i)))(:,2) = (dataset.(char(namesSpec(i)))(:,2))./feval(cf(i).GBand,max(cf(i).GBand.xc1,cf(i).GBand.xc2));
        
        fprintf('%s GPlusPeak_notNormalized %g \n',char(namesSpec(i)),feval(cf(i).GBand,max(cf(i).GBand.xc1,cf(i).GBand.xc2)));
        
    end
end




clf;


legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis


if strcmp('subplot',arrangement)

    for i=1:numSpec

        title = namesSpec(i);

        ax_ = subplot(ceil(numSpec/2),2,i); % Set Axis Handles
        set(ax_,'Box','on');
        axes(ax_); hold on;

        x = dataset.(char(namesSpec(i)))(:,1);
        y = dataset.(char(namesSpec(i)))(:,2);

        h_ = line(x,y,'Parent',ax_,'Color',[0.333333 0 0.666667],...
            'LineStyle','none', 'LineWidth',1,...
            'Marker','.', 'MarkerSize',12);
        xlim_(1) = min(xlim_(1),min(x));
        xlim_(2) = max(xlim_(2),max(x));
        legh_(1) = h_;
        legt_{1} = char(title);

        % Nudge axis limits beyond data limits
        if all(isfinite(xlim_))
            xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
            set(ax_,'XLim',xlim_)
        else
            set(ax_, 'XLim',[1256.7239210312313844, 1754.7171898414712814]);
        end


        hold off;
        leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'};
        h_ = legend(ax_,legh_,legt_,leginfo_{:});  % create legend
        set(h_,'Interpreter','none');
        xlabel(ax_,'cm^{-1}');               %  x label
        ylabel(ax_,'Raman Intensity');       %  y label
    end
elseif strcmp('single',arrangement)
    ax_ = axes; % Set Axis Handles
    set(ax_,'Box','on');
    axes(ax_); hold on;
    
    Color = [1 0 0;...
        1 0 1;... 
        0 1 1;...
        0 1 0;...
        0 0 1;...
        1 1 0;...
        0 0 0];
    
    %MarkerSpecifier = ['+' 'o' '*' '.' 'x' 'd'];
    
    for i=1:numSpec

        title = namesSpec(i);
        
        x = dataset.(char(namesSpec(i)))(:,1);
        y = dataset.(char(namesSpec(i)))(:,2);

        h_ = line(x,y,'Parent',ax_,'Color',Color(mod(i,7)+1,:),...
            'LineStyle','none', 'LineWidth',1,...
            'Marker','.', 'MarkerSize',12);
        xlim_(1) = min(xlim_(1),min(x));
        xlim_(2) = max(xlim_(2),max(x));
        legh_(end+1) = h_;
        legt_{end+1} = char(title);

        % Nudge axis limits beyond data limits
        if all(isfinite(xlim_))
            xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
            set(ax_,'XLim',xlim_)
        else
            set(ax_, 'XLim',[1256.7239210312313844, 1754.7171898414712814]);
        end 
    end
    hold off;
    leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'};
    h_ = legend(ax_,legh_,legt_,leginfo_{:});  % create legend
    set(h_,'Interpreter','none');
    xlabel(ax_,'cm^{-1}');               %  x label
    ylabel(ax_,'Raman Intensity');       %  y label
    
end












