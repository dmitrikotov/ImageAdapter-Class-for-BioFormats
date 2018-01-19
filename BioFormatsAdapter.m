classdef BioFormatsAdapter < ImageAdapter
    properties (GetAccess = public, SetAccess = private)
        Filename;
        Series;
        ImageOutput;
        ImageSize;
        VoxelSize;
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
          
          voxelSizeXdefaultValue = omeMeta.getPixelsPhysicalSizeX(0).value();           % returns value in default unit
          voxelSizeXdefaultUnit = omeMeta.getPixelsPhysicalSizeX(0).unit().getSymbol(); % returns the default unit type
          voxelSizeX = omeMeta.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROMETER); % in µm
          voxelSizeXdouble = voxelSizeX.doubleValue();                                  % The numeric value represented by this object after conversion to type double
          voxelSizeY = omeMeta.getPixelsPhysicalSizeY(0).value(ome.units.UNITS.MICROMETER); % in µm
          voxelSizeYdouble = voxelSizeY.doubleValue();                                  % The numeric value represented by this object after conversion to type double
          voxelSizeZ = omeMeta.getPixelsPhysicalSizeZ(0).value(ome.units.UNITS.MICROMETER); % in µm
          voxelSizeZdouble = voxelSizeZ.doubleValue();                                  % The numeric value represented by this object after conversion to type double
          
          obj.Filename = fname;
          obj.Series = series;
          obj.ImageSize = [stackSizeX stackSizeY stackSizeZ stackSizeC stackSizeT] %XYZCT
          obj.VoxelSize = [voxelSizeX voxelSizeY voxelSizeZ] 
          obj.region_size = [256 256 16]
          
          % Create the BigDataViewer object.
          obj.ImageOutput = writeBigDataXML(filename_base,hypervolume,dimensionorder,varargin);
          
          % Setup the BigDataViewer file properties.
          
          
        end
        
        function result = readRegion(obj,region_start)
            result = bfopen(obj.Filename.Series,...
                region_start(1):(region_start(1) + obj.region_size(1) - 1),...
                region_start(2):(region_start(2) + obj.region_size(2) - 1));
        end
        
        function [] = writeRegion(obj,dimensionorder,region_start,region_data)
            [] = writeBigDataXML(obj.Filename,region_data,dimensionorder,...
                'VoxelSize',obj.VoxelSize,region_start(1):(region_start(1) + obj.region_size(1) - 1),...
                region_start(2):(region_start(2) + obj.region_size(2) - 1)),varargin);
        end
        
        function [] = writeMergedRegion(obj, region_start, region_data)
        % calculate the X Y Z size for a merged image and then generate an
        % empty matrix of that size then fill the matrix block by block.
        end
        
        function result = close(obj) %#ok
        end
    end
    
end
