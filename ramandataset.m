classdef ramandataset < dataset
    properties
    ExperimentID
    SampleID
    ExciteWavelength
    DateTaken
    Apparatus
    end
    
    methods        
      function spec = ramandataset(varargin)
        %RAMANDATASET Class Constuctor
        % INPUT DATA: same way as if using the dataset class.      
          spec = spec@dataset(varargin{:});      
      end % END CONSTRUCTOR
        
    end % END METHODS
    
    methods
% %         OVERLOADING
    end

end % END CLASSDEF
