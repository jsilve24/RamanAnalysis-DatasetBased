classdef ramandataset < dataset
    properties
    ExperimentID
    SampleID
    ExciteWavelength
    DateTaken
    Apparatus
    end
    
    methods
        function spec = ramandataset(data,names)
        %RAMANDATASET Class Constuctor
        % INPUT DATA: spec = ramandataset(data,names);
        % where data is a double matrix of the form   
        % **********
        % k ri k ri k ri
        % **********
        % and names is a 1 by n cell array of strings with the names  
        
        if nargin == 0
            super_args{1} = [0];
            super_args{2} = '';
        else
           for i=1:size(data,2)/2 
                input = [];
                super_args{1} = data(:,2*i-1:2*i);
                super_args{2} = names{i};
                input = {input super_args};
           end %END FOR
        end %END IF
        
        spec = spec@dataset(input{:});
        
        
        end % END CONSTRUCTOR
    end % END METHODS
    
    methods
% %         OVERLOADING
    end

end % END CLASSDEF
