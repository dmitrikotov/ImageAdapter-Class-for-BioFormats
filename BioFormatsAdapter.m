classdef BioFormatsAdapter < ImageAdapter
    properties (GetAccess = public, SetAccess = private)
        Filename;
        ImageObject;
        TileLength;
        TileWidth;
    end
    methods
        function obj = BioFormatsReader(fname, imageLength, imageWidth, tileLength, tileWidth)
          %constructor
          
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
            
            % write BigDataViewer file
            % add information to pass 
            obj.ImageObject writeBigDataXML(filename_base,hypervolume,dimensionorder,varargin);
        
        end
    end
    
end
