classdef BioFormatsAdapter < ImageAdapter
    properties (GetAccess = public, SetAccess = private)
        Filename;
        Series;
        ZSlices;
        Channels;
        SizeX;
        SizeY;
        VoxelSize;
        DimensionOrder;
        Vols;
        %ImageOutput;
    end
    
    methods
        function obj = BioFormatsAdapter(fname,series,dimensionorder)
            %constructor
            
            reader = bfGetReader(fname);
            reader.setSeries(series-1);
            omeMeta = reader.getMetadataStore();
            stackSizeX = omeMeta.getPixelsSizeX(series-1).getValue(); % image width, pixels
            stackSizeY = omeMeta.getPixelsSizeY(series-1).getValue(); % image height, pixels
            stackSizeZ = omeMeta.getPixelsSizeZ(series-1).getValue(); % number of Z slices
            stackSizeT = omeMeta.getPixelsSizeT(series-1).getValue(); % number of timepoints
            stackSizeC = omeMeta.getPixelsSizeC(series-1).getValue(); % number of channels
            
            voxelSizeXdefaultValue = omeMeta.getPixelsPhysicalSizeX(0).value();           % returns value in default unit
            voxelSizeXdefaultUnit = omeMeta.getPixelsPhysicalSizeX(0).unit().getSymbol(); % returns the default unit type
            voxelSizeX = omeMeta.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROMETER); % in µm
            voxelSizeXdouble = voxelSizeX.doubleValue();                                  % The numeric value represented by this object after conversion to type double
            voxelSizeY = omeMeta.getPixelsPhysicalSizeY(0).value(ome.units.UNITS.MICROMETER); % in µm
            voxelSizeYdouble = voxelSizeY.doubleValue();                                  % The numeric value represented by this object after conversion to type double
            voxelSizeZ = omeMeta.getPixelsPhysicalSizeZ(0).value(ome.units.UNITS.MICROMETER); % in µm
            voxelSizeZdouble = voxelSizeZ.doubleValue();                                  % The numeric value represented by this object after conversion to type double
            
            %vols={};
            %vols = zeros(stackSizeX,stackSizeY,stackSizeZ,stackSizeC,'uint8');
            
            obj.Filename = fname;
            obj.Series = series;
            obj.ZSlices = stackSizeZ
            obj.Channels = stackSizeC
            obj.SizeX = stackSizeX
            obj.SizeY = stackSizeY
            obj.ImageSize = [stackSizeX stackSizeY stackSizeZ]
            obj.VoxelSize = [voxelSizeXdouble voxelSizeYdouble voxelSizeZdouble]
            obj.DimensionOrder = dimensionorder
            
            % Create the BigDataViewer object.
            %obj.ImageOutput = writeBigDataXML(filename_base,hypervolume,dimensionorder,varargin);
            
            % Setup the BigDataViewer file properties.
            
            
        end
        
        function vols = readRegion(obj,region_start,region_size)
            %Read in chunks of data for processing as chunks.
            
            reader = bfGetReader(obj.Filename);
            reader.setSeries(obj.Series - 1);
            z = obj.ZSlices;
            Channels = obj.Channels;
            vols = {}
            for ic = 0:Channels-1
                for iz = 0:z-1
                    iPlane = reader.getIndex(iz, ic, 0) + 1;
                    vols = bfGetPlane(reader,iPlane,region_start(1),region_start(2),...
                        region_size(1),region_size(2));
                    vols(:,:,iz+1) = reshape(vols,region_size(1),region_size(2)); %why?
                end
                Vol = cat(4,vols{:})
            end
            obj.Vols = Vol
        end
        
        %function [] = writeRegion(obj,region_start,region_data)
        % [] = writeBigDataXML
        %
        %        region_start(1):(region_start(1) + obj.region_size(1) - 1)
        %        region_start(2):(region_start(2) + obj.region_size(2) - 1)
        %
        %   writeBigDataXML(obj.Filename,obj.Vols,obj.DimensionOrder,'VoxelSize',obj.VoxelSize,varargin)
        %
        %   original format: writeBigDataXML(filename_base,hypervolume,dimensionorder,varargin)
        %
        %function [] = writeMergedRegion(obj, region_start, region_data)
        % Same as above but allow multiple series to be merged together
        % into a large image.
        %
        %end
        
        function result = close(obj) %#ok
        end
    end
    
end
