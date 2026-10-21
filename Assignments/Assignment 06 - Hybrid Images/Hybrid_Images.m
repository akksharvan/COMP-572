%{
COMP 572 - Assignment 06: Hybrid Images
Gaussian low/high-pass filtering is performed entirely in the Fourier domain.
Cutoffs are Gaussian standard deviations in DFT bins (not spatial pixels).
Nine cutoff combinations per pair were compared; final hybrids show two sizes.
Cat fur, bicycle spokes, feathers, fish scales, and citrus pulp supply near detail;
the far images retain broad face, vehicle, hull, and fruit shading.
Lower high-pass cutoffs retain more near-image structure; higher ones weaken it.
The personal mugs show a subtle texture change with residual rim/handle mismatch.
Set 6 uses my own photos IMG_1677.HEIC and IMG_1678.HEIC.
Source URLs for every downloaded input are listed below.
%}
close all;
root = fileparts(mfilename('fullpath'));
if isempty(root), root = pwd; end
if ~exist('show_figures','var'), show_figures = true; end
if ~exist('write_outputs','var'), write_outputs = false; end
if ~exist('run_experiments','var'), run_experiments = false; end
output_dir = fullfile(root,'results');
if write_outputs && ~isfolder(output_dir), mkdir(output_dir); end

% Inputs for sets 2, 3, 5 include a 40-pixel replicated guard border to
% retain objects during rotation and reduce edge artifacts; coordinates include it.
% Near landmarks are x1/y1; far landmarks are x2/y2. All are one-based.
% Crop endpoints x/y are in the aligned image, before the final crop.
% Set 1: supplied Derek/Nutmeg pair; eye centers. Nutmeg resized below 1 MP.
% https://lcms-files.mathworks.com/content/images/6c30a77d-d298-4f58-a114-f5bce78b049c.jpg
% https://lcms-files.mathworks.com/content/images/da802988-95a1-48b0-b641-7ca06105b87a.jpg
sets = struct('name','Derek and Nutmeg','far','derek.png','near','nutmeg.png', ...
    'gray',true,'x1',([605.1403 758.9682]-.5)*(1126/1408)+.5, ...
    'y1',([287.3709 360.6136]-.5)*(845/1056)+.5, ...
    'x2',[303.8974 442.5175],'y2',[348.1681 332.5175], ...
    'low',15,'high',10,'x',[90 680],'y',[370 1160]);
% Sets 2-4: source photographs from the Georgia Tech teaching archive.
% https://sites.cc.gatech.edu/classes/AY2016/cs4476_fall/proj1/proj1.zip
% Internal paths: proj1/data/{motorcycle,bicycle,plane,bird,submarine,fish}.bmp
% Set 2: wheel centers.
sets(2) = struct('name','Motorcycle to bicycle','far','motorcycle.png','near','bicycle.png', ...
    'gray',false,'x1',[128 410],'y1',[253 253],'x2',[129 414],'y2',[250 262], ...
    'low',11,'high',15,'x',[25 520],'y',[35 350]);
% Set 3: upper/lower wing tips.
sets(3) = struct('name','Plane to bird','far','plane.png','near','bird.png', ...
    'gray',false,'x1',[196 307],'y1',[99 339],'x2',[240 319],'y2',[100 321], ...
    'low',10,'high',14,'x',[40 393],'y',[65 350]);
% Set 4: nose and tail of the main subject.
sets(4) = struct('name','Submarine to fish','far','submarine.png','near','fish.png', ...
    'gray',false,'x1',[36 340],'y1',[171 132],'x2',[39 334],'y2',[155 125], ...
    'low',12,'high',24,'x',[15 359],'y',[18 296]);
% Set 5: left/right edges at the fruit's horizontal diameter.
% https://commons.wikimedia.org/wiki/File:Orange_sliced_on_white_background.jpg
% https://commons.wikimedia.org/wiki/File:Apple_(1).jpg
sets(5) = struct('name','Apple to orange','far','apple.png','near','orange.png', ...
    'gray',false,'x1',[154 653],'y1',[390 390],'x2',[238 788],'y2',[348 348], ...
    'low',10,'high',16,'x',[70 800],'y',[45 580]);
% Set 6: personally photographed mugs; align left/right rim endpoints.
% Inputs cropped from IMG_1677 and IMG_1678, then resized to 707 x 627 PNGs.
sets(6) = struct('name','Plain to blue-striped mug','far','mug_plain.png','near','mug_blue.png', ...
    'gray',false,'x1',([286 567]-240)*(707/530), ...
    'y1',([211 212]-150)*(627/470), ...
    'x2',([285 592]-240)*(707/530),'y2',([205 205]-150)*(627/470), ...
    'low',14,'high',18,'x',[185 790],'y',[450 995]);

results = cell(1,numel(sets));
for k = 1:numel(sets)
    s = sets(k);
    far = im2double(imread(fullfile(root,'images',s.far)));
    near = im2double(imread(fullfile(root,'images',s.near)));
    if s.gray, far = rgb2gray(far); near = rgb2gray(near); end
    x1=s.x1; y1=s.y1; x2=s.x2; y2=s.y2;
    % To reselect landmarks once: uncomment, then hard-code the returned values.
    % [x1,y1,x2,y2] = get_points_interactively(near,far);
    [near_aligned,far_aligned] = align_images(near,far,x1,y1,x2,y2);
    [hybrid,low_image,high_image,Ffar,Fnear,Flow,Fhigh,Glo,Ghi,residual] = ...
        hybridImage(far_aligned,near_aligned,s.low,s.high);
    x=s.x; y=s.y;
    assert(min(x)>=1 && max(x)<=size(hybrid,2) && min(y)>=1 && max(y)<=size(hybrid,1),'Invalid crop');
    rows=min(y):max(y); cols=min(x):max(x);
    hybrid=hybrid(rows,cols,:);
    results{k}=struct('name',s.name,'near',near,'far',far,'near_aligned',near_aligned, ...
        'far_aligned',far_aligned,'hybrid',hybrid,'low',low_image(rows,cols,:), ...
        'high',high_image(rows,cols,:),'imaginary_residual',residual);
    fprintf('Set %d: aligned %dx%d; crop %dx%d; imaginary residual %.3g\n',k, ...
        size(near_aligned,1),size(near_aligned,2),size(hybrid,1),size(hybrid,2),residual);
    % Retain signed, unclipped values for analysis. Clip only for display/export.
    shown=min(max(hybrid,0),1);
    viewed_from_afar=padarray(shown,[max(size(shown,1),size(shown,2)) max(size(shown,1),size(shown,2))]);
    if show_figures || write_outputs
        vis='off'; if show_figures, vis='on'; end
        f=figure('Visible',vis,'Name',s.name,'Position',[100 100 1050 800]);
        tiledlayout(2,2,'Padding','compact','TileSpacing','compact');
        nexttile; imshow(near); title('Near input');
        nexttile; imshow(far); title('Far input');
        nexttile; imshow(shown); title('Hybrid: view up close');
        nexttile; imshow(viewed_from_afar); title('Same hybrid: smaller viewing size');
        sgtitle(sprintf('Set %d: %s (low %g, high %g)',k,s.name,s.low,s.high));
        if write_outputs
            imwrite(shown,fullfile(output_dir,sprintf('set%d_hybrid.png',k)));
            imwrite(min(max(near_aligned,0),1),fullfile(output_dir,sprintf('set%d_near_aligned.png',k)));
            imwrite(min(max(far_aligned,0),1),fullfile(output_dir,sprintf('set%d_far_aligned.png',k)));
            exportgraphics(f,fullfile(output_dir,sprintf('set%d_comparison.png',k)),'Resolution',130);
        end
        if ~show_figures, close(f); end
    end
    if run_experiments && (~exist('experiment_sets','var') || ismember(k,experiment_sets))
        folder=fullfile(root,'experiments'); if ~isfolder(folder), mkdir(folder); end
        % Independent 3x3 sweep, with the selected pair in the center.
        lows=s.low*[0.6 1 1.6]; highs=s.high*[0.6 1 1.6];
        f=figure('Visible','off','Position',[0 0 1300 1100]);
        tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
        for a=1:3
            for b=1:3
                trial=hybridImage(far_aligned,near_aligned,lows(a),highs(b));
                trial=min(max(trial(rows,cols,:),0),1);
                nexttile; imshow(trial); title(sprintf('low %.1f / high %.1f',lows(a),highs(b)));
            end
        end
        sgtitle(sprintf('Set %d cutoff sweep: %s',k,s.name));
        exportgraphics(f,fullfile(folder,sprintf('set%d_cutoff_sweep.png',k)),'Resolution',120); close(f);
        f=figure('Visible','off','Position',[0 0 1400 750]);
        tiledlayout(2,4,'TileSpacing','compact');
        spectra={Ffar,Fnear,Flow,Fhigh}; labels={'Far spectrum','Near spectrum','Filtered far','Filtered near'};
        for j=1:4
            nexttile; imagesc(log1p(abs(spectra{j}(:,:,1)))); axis image off; title(labels{j});
        end
        nexttile; imagesc(Glo,[0 1]); axis image off; title('Gaussian low-pass');
        nexttile; imagesc(1-Ghi,[0 1]); axis image off; title('Gaussian high-pass');
        nexttile; imshow(min(max(low_image(rows,cols,:),0),1)); title('Low frequencies');
        nexttile; imshow(min(max(high_image(rows,cols,:)+0.5,0),1)); title('High frequencies + 0.5');
        colormap gray;
        exportgraphics(f,fullfile(folder,sprintf('set%d_frequency_analysis.png',k)),'Resolution',120); close(f);
    end
end
% Names matching the assignment template, available in the workspace.
set1_hybrid=results{1}.hybrid; set2_hybrid=results{2}.hybrid;
set3_hybrid=results{3}.hybrid; set4_hybrid=results{4}.hybrid;
set5_hybrid=results{5}.hybrid; set6_hybrid=results{6}.hybrid;
if write_outputs, save(fullfile(output_dir,'hybrid_results.mat'),'results','sets'); end

function [im12,low,high,F1,F2,L,H,G1,G2,residual] = hybridImage(im1,im2,cutoff_low,cutoff_high)
    assert(isequal(size(im1),size(im2)),'Aligned inputs must have identical sizes.');
    assert(cutoff_low>0 && cutoff_high>0,'Cutoffs must be positive.');
    [h,w,~]=size(im1);
    G1=frequencyGaussian(h,w,cutoff_low);
    G2=frequencyGaussian(h,w,cutoff_high);
    % Shift spatial dimensions only, preserving RGB channel order.
    F1=fftshift(fftshift(fft2(im1),1),2);
    F2=fftshift(fftshift(fft2(im2),1),2);
    L=F1.*G1;
    H=F2.*(1-G2);
    spatial=ifft2(ifftshift(ifftshift(L+H,1),2));
    im12=real(spatial);
    if nargout>1
        low=real(ifft2(ifftshift(ifftshift(L,1),2)));
        high=real(ifft2(ifftshift(ifftshift(H,1),2)));
        residual=max(abs(imag(spatial)),[],'all');
    end
end

function G=frequencyGaussian(h,w,sigma)
    % fspecial centers even-sized kernels between pixels. Build an odd grid
    % and trim its last row/column when necessary so DC is exactly at
    % (floor(h/2)+1,floor(w/2)+1), including for even-sized FFT arrays.
    G=fspecial('gaussian',[2*floor(h/2)+1 2*floor(w/2)+1],sigma);
    G=G(1:h,1:w);
    G=G/max(G,[],'all');
end

% Instructor-provided alignment helpers, unchanged.
function [x1, y1, x2, y2] = get_points_interactively(im1, im2)
    % displays image and gets two points from the user
    fig=figure; hold off, imagesc(im1), axis image;
    disp('Select two points from each image define rotation, scale, translation')
    figure(fig)
    [x1, y1] = ginput(2);
    figure(fig); hold off, imagesc(im2), axis image;
    figure(fig)
    [x2, y2] = ginput(2);
    close(fig);
end

function [im1, im2] = align_images(im1, im2, x1, y1, x2, y2)
    % Aligns im1 and im2 (translation, scale, rotation) after getting two pairs
    % of points from the user.  In the output of im1 and im2, the two pairs of
    % points will have approximately the same coordinates.
    
    % get image sizes
    [h1, w1, ~] = size(im1);
    [h2, w2, ~] = size(im2);
    
    cx1 = mean(x1); cy1 = mean(y1);
    cx2 = mean(x2); cy2 = mean(y2);
    
    % translate first so that center of ref points is center of image
    tx = round((w1/2-cx1)*2);
    if tx > 0,  im1 = padarray(im1, [0 tx], 'pre');
    else        im1 = padarray(im1, [0 -tx], 'post');
    end
    ty = round((h1/2-cy1)*2);
    if ty > 0,  im1 = padarray(im1, [ty 0], 'pre');
    else        im1 = padarray(im1, [-ty 0], 'post');
    end  
    tx = round((w2/2-cx2)*2) ;
    if tx > 0,  im2 = padarray(im2, [0 tx], 'pre');
    else        im2 = padarray(im2, [0 -tx], 'post');
    end
    ty = round((h2/2-cy2)*2);
    if ty > 0,  im2 = padarray(im2, [ty 0], 'pre');
    else        im2 = padarray(im2, [-ty 0], 'post');
    end
    
    % downscale larger image so that lengths between ref points are the same
    len1 = sqrt((y1(2)-y1(1)).^2+(x1(2)-x1(1)).^2);
    len2 = sqrt((y2(2)-y2(1)).^2+(x2(2)-x2(1)).^2);
    dscale = len2 ./ len1;
    if dscale < 1
        im1 = imresize(im1, dscale, 'bilinear'); 
    else
        im2 = imresize(im2, 1./dscale, 'bilinear');
    end
    
    % rotate im1 so that angle between points is the same
    theta1 = atan2(-(y1(2)-y1(1)), x1(2)-x1(1)); % in matlab, y==1 is at the top of the N x M image, and y==N is at the bottom
    theta2 = atan2(-(y2(2)-y2(1)), x2(2)-x2(1));
    dtheta = theta2-theta1;
    im1 = imrotate(im1, dtheta*180/pi, 'bilinear'); % imrotate uses degree units
    
    % Crop images (on both sides of border) to be same height and width
    [h1, w1, ~] = size(im1);
    [h2, w2, ~] = size(im2);
    
    minw = min(w1, w2);
    brd = (max(w1, w2)-minw)/2;
    if minw == w1 % crop w2
        im2 = im2(:, (ceil(brd)+1):end-floor(brd), :);
        tx = tx-ceil(brd);
    else
        im1 = im1(:, (ceil(brd)+1):end-floor(brd), :);
        tx = tx+ceil(brd);    
    end
    
    minh = min(h1, h2);
    brd = (max(h1, h2)-minh)/2;
    if minh == h1 % crop w2
        im2 = im2((ceil(brd)+1):end-floor(brd), :, :);
        ty = ty-ceil(brd);
    else
        im1 = im1((ceil(brd)+1):end-floor(brd), :, :);
        ty = ty+ceil(brd);    
    end    
end
