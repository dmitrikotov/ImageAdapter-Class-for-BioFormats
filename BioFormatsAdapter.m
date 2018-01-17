classdef BioFormatsAdapter < ImageAdapter
    properties (GetAccess = public, SetAccess = private)
        Filename;
        Series;
        Metadata;
        TileLength;
        TileWidth;
    end
    
    methods
        function obj = BioFormatsReader(fname)
          %constructor
          
          reader = bfGetReader(fname);
          nSeries = reader.getSeriesCount();
          
          for i_series = 1:nSeries
            reader.setSeries(i_series-1);
            omeMeta = reader.getMetadataStore();
            stackSizeX = omeMeta.getPixelsSizeX(i_series-1).getValue(); % image width, pixels
            stackSizeY = omeMeta.getPixelsSizeY(i_series-1).getValue(); % image height, pixels
            stackSizeZ = omeMeta.getPixelsSizeZ(i_series-1).getValue(); % number of Z slices
            stackSizeT = omeMeta.getPixelsSizeT(i_series-1).getValue(); % number of timepoints
            stackSizeC = omeMeta.getPixelsSizeC(i_series-1).getValue(); % number of channels
            
            if ~strcmp(char(omeMeta.getPixelsType(0)),'uint8')
                error('Only works with 8bit')
            end
          end
            
          validateattributes (fname,       {'char'},    {'row'});
          validateattributes (imageLength, {'numeric'}, {'scalar'});
          validateattributes (imageWidth,  {'numeric'}. {'scalar'});
          validateattributes (tileLength,  {'numeric'}, {'scalar'});
          validateattributes (tileWidth,   {'numeric'}, {'scalar'});
          
            if(mod(tileLength,16)~=0 || mod(tileWidth,16)~=0)
                error('BioFormatsAdapter:invalidTileSize',...
                    'Tile size must be a multiple of 16');
            end
            
            obj.Filename = fname;
            obj.ImageSize = [imageLength, imageWidth, 1];
            obj.TileLength = tileLength;
            obj.TileWidth = tileWidth;
        end
            
            % write BigDataViewer file
            % add information to pass metadata like voxel size to the
            % BigDataViewer file.
            % obj.ImageObject writeBigDataXML(filename_base,hypervolume,dimensionorder,varargin);
        
        function result = readRegion(obj, start, count)
            result = bfopen(obj.Filename,'Index',obj.Page,...
                'Info',obj.Info,'PixelRegion', ...
                {[start(1), start(1) + count(1) - 1], ...
                [start(2), start(2) + count(2) - 1]});
        end
        
        function [] = writeRegion(obj, region_start, region_data)
        end
        
        function result = close(obj) %#ok
        end
    end
    
end
