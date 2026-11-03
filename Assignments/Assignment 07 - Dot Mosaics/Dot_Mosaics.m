%{
COMP 572 - Assignment 07: Dot Mosaics
Each downsampled pixel becomes a white cell containing a centered black disk.
Disk radius is proportional to sqrt(1-p), so ink area follows darkness.
The color version applies exactly the same operation to R, G, and B.
Images 1-3: grayscale. Images 4-6: color. Image 6 must be my own photo.

Downloaded image sources (prepared PNGs are in images/):
1. Orren Jack Turner, Albert Einstein, 1947; public domain in the US.
   https://commons.wikimedia.org/wiki/File:Albert_Einstein_Head.jpg
2. Alvesgaspar, young tabby cat; CC BY-SA 3.0. Cropped and resized.
   https://commons.wikimedia.org/wiki/File:Cat_November_2010-1a.jpg
   https://creativecommons.org/licenses/by-sa/3.0/
   Cat-derived images are distributed under that same license.
3. Shellcreek, West Point Lighthouse; CC0. Resized.
   https://commons.wikimedia.org/wiki/File:West_Point_Lighthouse._Seattle.jpg
4. Don McCulley, sunflower; CC0. Resized.
   https://commons.wikimedia.org/wiki/File:Sunflower_Public_Domain.jpg
5. NASA / Apollo 17 crew, The Blue Marble; public domain. Resized.
   https://commons.wikimedia.org/wiki/File:The_Earth_seen_from_Apollo_17.jpg
6. My photograph IMG_1711.HEIC: Tree Rex in a miniature vegetable landscape.
   Backdrop cleaned, straightened, cropped, and converted to RGB PNG.
   The generated guidance image is excluded from the assignment inputs.

Local run: open this script and click Run. Requires Image Processing Toolbox.
After the images are uploaded to GitHub, fill repository_images below with
the verified raw image-folder URL, ending in '/'; then this file also runs
as a single MATLAB Grader script without its local image folder.
%}
close all;
root = fileparts(mfilename('fullpath'));
if isempty(root), root = pwd; end
if ~exist('show_figures','var'), show_figures = true; end
if ~exist('write_outputs','var'), write_outputs = true; end
if ~exist('run_experiments','var'), run_experiments = false; end
repository_images = 'https://raw.githubusercontent.com/akksharvan/COMP-572/main/Assignments/Assignment%2007%20-%20Dot%20Mosaics/images/';
output_dir = fullfile(root,'results');
if write_outputs && ~isfolder(output_dir), mkdir(output_dir); end

files = {'einstein.png','tabby.png','lighthouse.png', ...
         'sunflower.png','earth.png','personal_toy.png'};
names = {'Einstein portrait','Tabby cat','West Point Lighthouse', ...
         'Sunflower','The Blue Marble','Tree Rex in a vegetable landscape'};
methods = {'gray','gray','gray','color','color','color'};
dot_sizes = [52 48 46 42 56 64];
results = cell(1,6);

for image_number = 1:6
    path = fullfile(root,'images',files{image_number});
    if ~isfile(path)
        if image_number == 6 && isempty(repository_images)
            warning('Assignment07:PersonalPhotoPending', ...
                'Image 6 pending: add your own photograph as images/personal_toy.png.');
            continue;
        end
        assert(~isempty(repository_images), ...
            'Image missing: %s. Supply local images or the verified GitHub URL.',path);
        path = [repository_images files{image_number}];
    end
    im = im2double(imread(path));
    % Limit large replacements to approximately 0.85 MP; never upsample inputs.
    scale = min(1,sqrt(850000/(size(im,1)*size(im,2))));
    if scale < 1, im = imresize(im,scale,'box'); end
    im = min(max(im,0),1);
    if strcmp(methods{image_number},'gray')
        if size(im,3) == 3, im = rgb2gray(im); end
        [mosaic,grid] = dot_mosaic_gray(im,dot_sizes(image_number));
    else
        [mosaic,grid] = dot_mosaic_color(im,dot_sizes(image_number));
    end
    results{image_number} = struct('name',names{image_number}, ...
        'method',methods{image_number},'Size',dot_sizes(image_number), ...
        'grid',grid,'original',im,'mosaic',mosaic);
    fprintf('Image %d: %s; Size=%g; grid=%dx%d; k=%d; output=%dx%d\n', ...
        image_number,names{image_number},dot_sizes(image_number), ...
        grid.rows,grid.columns,grid.k,size(mosaic,1),size(mosaic,2));
    if show_figures || write_outputs
        visibility = 'off'; if show_figures, visibility = 'on'; end
        f = figure('Visible',visibility,'Color','w','Name',names{image_number}, ...
            'Position',[80 80 1400 850]);
        montage({im,mosaic},'Size',[1 2],'BorderSize',[12 12], ...
            'BackgroundColor','w');
        title(sprintf('%d. %s | Original / %s mosaic | Size %d | %d x %d dots', ...
            image_number,names{image_number},methods{image_number}, ...
            dot_sizes(image_number),grid.rows,grid.columns),'Color','k');
        if write_outputs
            imwrite(mosaic,fullfile(output_dir,sprintf('image%d_mosaic.png',image_number)));
            exportgraphics(f,fullfile(output_dir,sprintf('image%d_comparison.png',image_number)), ...
                'Resolution',150);
        end
        if ~show_figures, close(f); end
    end
    if run_experiments && (~exist('experiment_images','var') || ismember(image_number,experiment_images))
        folder = fullfile(root,'experiments');
        if ~isfolder(folder), mkdir(folder); end
        trials = round(dot_sizes(image_number)*[0.65 1 1.5]);
        f = figure('Visible','off','Color','w','Position',[50 50 1800 800]);
        for j = 1:numel(trials)
            if strcmp(methods{image_number},'gray')
                [trial,info] = dot_mosaic_gray(im,trials(j));
            else
                [trial,info] = dot_mosaic_color(im,trials(j));
            end
            ax = axes(f,'Position',[(j-1)/3+.01 .06 .31 .76]);
            imshow(trial,'Parent',ax);
            annotation(f,'textbox',[(j-1)/3+.01 .85 .31 .04], ...
                'String',sprintf('Size %d: %d x %d dots, k=%d', ...
                trials(j),info.rows,info.columns,info.k), ...
                'HorizontalAlignment','center','EdgeColor','none','Color','k');
        end
        annotation(f,'textbox',[0 .94 1 .04],'String',names{image_number}, ...
            'HorizontalAlignment','center','EdgeColor','none','Color','k','FontSize',18);
        exportgraphics(f,fullfile(folder,sprintf('image%d_resolution_sweep.png',image_number)), ...
            'Resolution',150);
        close(f);
    end
end
if write_outputs
    save(fullfile(output_dir,'dot_mosaic_results.mat'),'results','files','methods','dot_sizes');
end
% Function handles allow the local implementation to be checked by Verify_Dot_Mosaics.
mosaic_functions = struct('gray',@dot_mosaic_gray,'color',@dot_mosaic_color);

function [result,grid] = dot_mosaic_gray(im,Size)
    validateattributes(im,{'numeric','logical'}, ...
        {'real','finite','nonempty','2d','>=',0,'<=',1});
    validateattributes(Size,{'numeric'},{'scalar','real','finite','>=',1});
    im = double(im);
    shorter = min(size(im));
    % Compare odd neighbors of the ideal cell width. A minimum of 3 avoids
    % degenerate 1-pixel cells, which cannot represent variable-size disks.
    lower = 2*floor((shorter/Size-1)/2)+1;
    candidates = unique(max(3,[lower lower+2]));
    short_counts = max(1,round(shorter./candidates));
    [~,best] = min(abs(short_counts-Size));
    k = candidates(best);
    short_count = short_counts(best);
    % Specify only the shorter dimension; imresize preserves aspect ratio.
    if size(im,1) <= size(im,2)
        reduced = imresize(im,[short_count NaN],'box');
    else
        reduced = imresize(im,[NaN short_count],'box');
    end
    reduced = min(max(reduced,0),1);
    [M,N] = size(reduced);
    cells = cell(M,N);
    max_radius = (k-1)/2; % 2*max_radius+1=k: every disk fits its cell.
    for row = 1:M
        for column = 1:N
            square = ones(k,k);
            p = reduced(row,column);
            if p < 1
                radius = max_radius*sqrt(1-p);
                disk = fspecial('disk',radius);
                disk = 1-disk/max(disk(:));
                first = (k-size(disk,1))/2+1;
                indices = first:first+size(disk,1)-1;
                square(indices,indices) = disk;
            end
            cells{row,column} = square;
        end
    end
    result = cell2mat(cells);
    grid = struct('rows',M,'columns',N,'k',k);
end

function [result,grid] = dot_mosaic_color(im,Size)
    validateattributes(im,{'numeric','logical'}, ...
        {'real','finite','nonempty','>=',0,'<=',1});
    assert(ndims(im)==3 && size(im,3)==3,'Color input must be an RGB image.');
    [red,grid] = dot_mosaic_gray(im(:,:,1),Size);
    green = dot_mosaic_gray(im(:,:,2),Size);
    blue = dot_mosaic_gray(im(:,:,3),Size);
    result = cat(3,red,green,blue);
end
