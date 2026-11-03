%% AI Usage Report
%{
1. AI tool used: OpenAI Codex.
2. Example prompts: "Complete Assignment 07" and "Clean it up (especially
   the backdrop), straighten it up, and crop it. Convert to a PNG."
3. AI-generated work: the main MATLAB script, dot_mosaic_gray(),
   dot_mosaic_color(), verification code, and resolution comparison code.
   Codex also selected the downloaded images and suggested Size parameters.
4. My contributions: I provided the assignment requirements, chose my toy,
   arranged the scene, and personally took IMG_1711.HEIC. I requested photo
   cleanup and submission. Codex performed the MATLAB debugging, testing,
   parameter comparisons, and conventional photo edits; I did not
   independently modify the MATLAB implementation.
%}

% COMP 572 - Assignment 07: Dot Mosaics
% Images 1-3: grayscale; images 4-6: color.
% Source photographs and credits:
% 1. Orren Jack Turner, Einstein, 1947 (public domain in the US):
% https://commons.wikimedia.org/wiki/File:Albert_Einstein_Head.jpg
% 2. Alvesgaspar, tabby cat (cropped/resized, CC BY-SA 3.0):
% https://commons.wikimedia.org/wiki/File:Cat_November_2010-1a.jpg
% https://creativecommons.org/licenses/by-sa/3.0/
% Cat image adaptations are distributed under the same license.
% 3. Shellcreek, lighthouse (CC0):
% https://commons.wikimedia.org/wiki/File:West_Point_Lighthouse._Seattle.jpg
% 4. Don McCulley, sunflower (CC0):
% https://commons.wikimedia.org/wiki/File:Sunflower_Public_Domain.jpg
% 5. NASA / Apollo 17 crew, Earth (public domain):
% https://commons.wikimedia.org/wiki/File:The_Earth_seen_from_Apollo_17.jpg
% 6. My own camera photo IMG_1711.HEIC: Tree Rex and vegetables.
% The wall backdrop was cleaned, then the photo was straightened/cropped
% and converted to PNG. The photographed objects were retained.
% Generated guidance images are excluded from these six inputs.

close all;
base = 'https://raw.githubusercontent.com/akksharvan/COMP-572/main/Assignments/Assignment%2007%20-%20Dot%20Mosaics/images/';
files = {'einstein.png','tabby.png','lighthouse.png', ...
    'sunflower.png','earth.png','personal_toy.png'};
names = {'Einstein portrait','Tabby cat','West Point Lighthouse', ...
    'Sunflower','The Blue Marble','Tree Rex in a vegetable landscape'};
dot_sizes = [52 48 46 42 56 64];
results = cell(1,6);
for image_number = 1:6
    im = im2double(imread([base files{image_number}]));
    % Keep the input at approximately 0.85 MP without enlarging small inputs.
    scale = min(1,sqrt(850000/(size(im,1)*size(im,2))));
    if scale < 1, im = imresize(im,scale,'box'); end
    im = min(max(im,0),1);
    if image_number <= 3
        im = rgb2gray(im);
        [mosaic,grid] = dot_mosaic_gray(im,dot_sizes(image_number));
        method = 'grayscale';
    else
        [mosaic,grid] = dot_mosaic_color(im,dot_sizes(image_number));
        method = 'color';
    end
    results{image_number} = struct('original',im,'mosaic',mosaic,'grid',grid);
    figure('Color','w');
    montage({im,mosaic},'Size',[1 2],'BorderSize',[12 12],'BackgroundColor','w');
    title(sprintf('%d. %s | Original / %s mosaic | Size %d | %d x %d dots', ...
        image_number,names{image_number},method,dot_sizes(image_number), ...
        grid.rows,grid.columns),'Color','k');
    fprintf('Image %d: Size %d; grid %d x %d; odd cell width k=%d\n', ...
        image_number,dot_sizes(image_number),grid.rows,grid.columns,grid.k);
end

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
