classdef BioFormatsAdapter < ImageAdapter
    properties (GetAccess = public, SetAccess = private)
        Filename;
        Series;
        StackSizeX;
        StackSizeY;
        StackSizeZ;
        StackSizeT;
        StackSizeC;
    end
    
    methods
        function obj = BioFormatsReader(fname, series)
          %constructor
          
          reader = bfGetReader(fname);
          reader.setSeries(series-1);
          omeMeta = reader.getMetadataStore();
          stackSizeX = omeMeta.getPixelsSizeX(series-1).getValue(); % image width, pixels
          stackSizeY = omeMeta.getPixelsSizeY(series-1).getValue(); % image height, pixels
          stackSizeZ = omeMeta.getPixelsSizeZ(series-1).getValue(); % number of Z slices
          stackSizeT = omeMeta.getPixelsSizeT(series-1).getValue(); % number of timepoints
          stackSizeC = omeMeta.getPixelsSizeC(series-1).getValue(); % number of channels
          
          if ~strcmp(char(omeMeta.getPixelsType(0)),'uint8')
              error('Only works with 8bit')
          end
          
          obj.Filename = fname;
          obj.Series = series;          
          obj.StackSizeX = stackSizeX;
          obj.StackSizeY = stackSizeY;
          obj.StackSizeZ = stackSizeZ;
          obj.StackSizeT = stackSizeT;
          obj.StackSizeC = stackSizeC;
          
        end
            
            % write BigDataViewer file
            % add information to pass metadata like voxel size to the
            % BigDataViewer file.
            % obj.ImageObject writeBigDataXML(filename_base,hypervolume,dimensionorder,varargin);
        
            
            % figure out how to specify Series for reading
        function result = readRegion(obj, start, count)
            result = bfopen(obj.Filename,obj.Page,obj.Info,
                {[start(1), start(1) + count(1) - 1],
                [start(2), start(2) + count(2) - 1]});
        end
        
        function [] = writeRegion(obj, region_start, region_data)
        end
        
        function result = close(obj) %#ok
        end
    end
    
end
