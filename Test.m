% Get some image information, we'll need this later.
filename = 'Compensation.lif';
series = 2;
addpath ('C:\Program Files\bfmatlab');

% Create our PagedTiffAdapter object!
my_adapter = BioFormatsAdapter(filename,series);

% Let's not "do" anything to the data, let's just read it and return it
no_op_fun = @(bs) bs.data;

% Call blockproc using our image adapter object as the input source
single_page = blockproc(my_adapter,[512 512],no_op_fun);

% Display our single page from this TIFF file
imshow(single_page,'Colormap',hsv)