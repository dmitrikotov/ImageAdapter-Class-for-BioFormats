filename = 'Compensation.lif';
series = 2;
dimensionorder = 'XYZC';
addpath ('C:\Program Files\bfmatlab');
region_start = [1 1];
region_size = [512 512];

reader = bfGetReader(filename);
reader.setSeries(series - 1);
omeMeta = reader.getMetadataStore();
stackSizeZ = omeMeta.getPixelsSizeZ(series-1).getValue(); % number of Z slices
stackSizeT = omeMeta.getPixelsSizeT(series-1).getValue(); % number of timepoints
stackSizeC = omeMeta.getPixelsSizeC(series-1).getValue(); % number of channels
vols={};
    vols = zeros(region_size(1),region_size(2),stackSizeZ,stackSizeC,'uint8'); 
    for ic = 0:stackSizeC-1
        for iz = 0:stackSizeZ-1
            iPlane = reader.getIndex(iz, ic, 0) + 1;
            vols = bfGetPlane(reader,iPlane,region_start(1),region_start(2),...
                region_size(1),region_size(2));
            vols(:,:,iz+1,ic+1) = reshape(vols,region_size(1),region_size(2));
        end
    end

%vols = {};
%for it = 0:obj.Timepoints-1
%    vols{it+1} = zeros(obj.SizeX,obj.SizeY,obj.ZSlices,obj.Channels,'uint8');
%    for ic = 0:obj.Channels-1
%        for iz = 0:obj.ZSlices-1
%            iPlane = reader.getIndex(iz, ic, it) + 1;
%            plane = typecast(reader.openBytes(iPlane-1),'uint8');
%            vols{it+1}(:,:,iz+1,ic+1) = reshape(plane,obj.SizeX,obj.SizeY);
%        end
%    end
% end