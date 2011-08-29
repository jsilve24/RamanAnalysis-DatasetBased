classdef ramandataset < dataset
    properties
    ExperimentID
    SampleID
    ExciteWavelength
    DateTaken
    Apparatus
    end
    
    methods
        function spec = ramandataset(data,name)
        %RAMANDATASET Class Constuctor
        % INPUT DATA: spec = ramandataset(data,names);
        % where data is a double matrix of the form   
        % **********
        % k ri k ri k ri
        % **********
        % and names is a 1 by n cell array of strings with the names  
        
        
        
        spec = spec@dataset({data,name});
        
        end
        
        
%                
%             if nargin == 0
%                 spec = dataset();
%             elseif isa(data,'ramandataset')
%                 spec = dataset(); 
% %             elseif numel(varargin)==1
%             else %if numel(varargin)==2
%                 if size(data,2)/2 == numel(names)
%                     spec = dataset();
% %                     for i=1:numel(names)
% %                         spec = [spec dataset({data(:,2*i-1:2*i),names{i}})];
%                     spec = dataset({data(:,:),names});
% %                     end %END FOR            
%                 end %END IF 
%             end %END IF
%             get(spec);
%         end %END Class Constuctor
    end
    
    methods
        
    end

end % END CLASSDEF
