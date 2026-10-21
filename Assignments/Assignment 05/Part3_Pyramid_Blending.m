close('all');

show_figures = true;
write_outputs = false;
% The batch runner can override display and export without editing this script.
if exist('assignment_show_figures', 'var')
    show_figures = assignment_show_figures;
end
if exist('assignment_write_outputs', 'var')
    write_outputs = assignment_write_outputs;
end

script_path = mfilename('fullpath');
if isempty(script_path)
    root_folder = pwd;
else
    root_folder = fileparts(script_path);
end

sets = assignment_image_sets();
method_name = 'Laplacian pyramid blending';
output_folder = fullfile(root_folder, 'outputs', 'exercise3');
if write_outputs && ~isfolder(output_folder)
    mkdir(output_folder);
end

result1 = [];
result2 = [];
result3 = [];
result4 = [];
result5 = [];
completed_sets = [];

if sets(1).ready
    im_bg = read_assignment_image(root_folder, 'images/swim.jpg');
    im_obj = read_assignment_image(root_folder, 'images/bear.jpg');

    poly_x = [276.4628 324.9961 391.5884 425.4488 ...
        453.6659 457.0519 433.3496 442.3791 ...
        441.2504 348.6984 248.2457 222.2860 ...
        238.0876 226.8008 222.2860 214.3853 ...
        224.5434 248.2457];
    poly_y = [255.3512 238.4209 255.3512 250.8364 ...
        260.9946 283.5682 329.8442 349.0318 ...
        404.3372 419.0101 404.3372 356.9326 ...
        342.2597 308.3992 292.5977 265.5093 ...
        250.8364 247.4504];
    objmask = poly2mask(poly_x, poly_y, size(im_obj, 1), size(im_obj, 2));

    center_x = 575.9264;
    bottom_y = 432.4922;
    padding = 64;
    validate_image_set_geometry(im_bg, im_obj, objmask, poly_x, poly_y, ...
        center_x, bottom_y, padding, sets(1));
    [im_s, mask_s] = alignSource(im_obj, objmask, im_bg, ...
        center_x, bottom_y, padding);
    mask_s = im2double(mask_s);

    levels = 6;
    result1 = laplacian_blend(im_bg, im_s, mask_s, levels);
    completed_sets(end + 1) = 1;

    result_display = min(max(result1, 0), 1);
    if show_figures
        mask_rgb = repmat(mask_s, [1 1 3]);
        figure('Name', sprintf('Result 1 - %s', method_name), ...
            'NumberTitle', 'off');
        montage({im_bg, im_obj, mask_rgb, result_display}, 'Size', [2 2]);
        title(sprintf('Result 1: %s | %s', sets(1).name, method_name), ...
            'Interpreter', 'none');
    end
    if write_outputs
        imwrite(result_display, fullfile(output_folder, 'result1.png'));
    end
    fprintf('Computed result1: %s (%s).\n', sets(1).name, method_name);
else
    warning('Assignment:PendingImageSet', ...
        'result1 has no saved selection (%s).', ...
        sets(1).name);
end

if sets(2).ready
    im_bg = read_assignment_image(root_folder, 'images/set2_background.jpg');
    im_obj = read_assignment_image(root_folder, 'images/set2_source.jpg');

    poly_x = [363.19047619047632 413.78754578754587 467.04761904761909 520.30769230769238 ...
        560.25274725274721 588.65811965811963 607.29914529914527 610.84981684981699 ...
        604.6361416361417 583.33211233211227 546.93772893772893 500.77899877899887 ...
        447.51892551892547 387.15750915750925 363.19047619047632];
    poly_y = [107.46398046398053 107.46398046398053 123.44200244200249 153.62271062271066 ...
        198.89377289377296 248.60317460317464 307.18925518925522 366.66300366300374 ...
        427.02442002442007 480.28449328449335 528.21855921855922 562.83760683760693 ...
        586.80463980463981 598.34432234432234 598.34432234432234];
    objmask = poly2mask(poly_x, poly_y, size(im_obj, 1), size(im_obj, 2));

    center_x = 570.28021978021968;
    bottom_y = 573.02747252747258;
    padding = 64;
    validate_image_set_geometry(im_bg, im_obj, objmask, poly_x, poly_y, ...
        center_x, bottom_y, padding, sets(2));
    [im_s, mask_s] = alignSource(im_obj, objmask, im_bg, ...
        center_x, bottom_y, padding);
    mask_s = im2double(mask_s);

    levels = 6;
    result2 = laplacian_blend(im_bg, im_s, mask_s, levels);
    completed_sets(end + 1) = 2;

    result_display = min(max(result2, 0), 1);
    if show_figures
        mask_rgb = repmat(mask_s, [1 1 3]);
        figure('Name', sprintf('Result 2 - %s', method_name), ...
            'NumberTitle', 'off');
        montage({im_bg, im_obj, mask_rgb, result_display}, 'Size', [2 2]);
        title(sprintf('Result 2: %s | %s', sets(2).name, method_name), ...
            'Interpreter', 'none');
    end
    if write_outputs
        imwrite(result_display, fullfile(output_folder, 'result2.png'));
    end
    fprintf('Computed result2: %s (%s).\n', sets(2).name, method_name);
else
    warning('Assignment:PendingImageSet', ...
        'result2 has no saved selection (%s).', ...
        sets(2).name);
end

if sets(3).ready
    im_bg = read_assignment_image(root_folder, 'images/set3_background.jpg');
    im_obj = read_assignment_image(root_folder, 'images/set3_source.jpg');

    poly_x = [133.42307692307696 175.26923076923083 239.88461538461542 304.5 ...
        369.11538461538464 415.26923076923083 433.73076923076928 406.03846153846155 ...
        341.42307692307691 253.42307692307696 175.26923076923083 130.96153846153851];
    poly_y = [274.65384615384613 221.11538461538458 189.11538461538458 187.88461538461536 ...
        200.80769230769226 245.11538461538458 287.57692307692304 329.42307692307691 ...
        355.26923076923077 355.26923076923077 334.96153846153845 305.42307692307691];
    objmask = poly2mask(poly_x, poly_y, size(im_obj, 1), size(im_obj, 2));

    center_x = 741.13369963369962;
    bottom_y = 630.60622710622715;
    padding = 64;
    validate_image_set_geometry(im_bg, im_obj, objmask, poly_x, poly_y, ...
        center_x, bottom_y, padding, sets(3));
    [im_s, mask_s] = alignSource(im_obj, objmask, im_bg, ...
        center_x, bottom_y, padding);
    mask_s = im2double(mask_s);

    levels = 6;
    result3 = laplacian_blend(im_bg, im_s, mask_s, levels);
    completed_sets(end + 1) = 3;

    result_display = min(max(result3, 0), 1);
    if show_figures
        mask_rgb = repmat(mask_s, [1 1 3]);
        figure('Name', sprintf('Result 3 - %s', method_name), ...
            'NumberTitle', 'off');
        montage({im_bg, im_obj, mask_rgb, result_display}, 'Size', [2 2]);
        title(sprintf('Result 3: %s | %s', sets(3).name, method_name), ...
            'Interpreter', 'none');
    end
    if write_outputs
        imwrite(result_display, fullfile(output_folder, 'result3.png'));
    end
    fprintf('Computed result3: %s (%s).\n', sets(3).name, method_name);
else
    warning('Assignment:PendingImageSet', ...
        'result3 has no saved selection (%s).', ...
        sets(3).name);
end

if sets(4).ready
    im_bg = read_assignment_image(root_folder, 'images/set4_background.jpg');
    im_obj = read_assignment_image(root_folder, 'images/set4_source.jpg');

    poly_x = [234.73076923076914 274.78205128205116 310.88461538461524 334.01282051282044 ...
        343.03846153846143 334.57692307692298 310.88461538461524 275.3461538461537 ...
        234.73076923076914 193.55128205128199 159.70512820512818 136.0128205128205 ...
        126.42307692307689 134.88461538461536 158.57692307692304 195.24358974358967];
    poly_y = [110.78205128205127 119.24358974358974 141.80769230769232 176.78205128205127 ...
        216.26923076923077 256.88461538461536 291.85897435897431 313.85897435897431 ...
        322.88461538461536 314.42307692307691 291.85897435897431 256.88461538461536 ...
        216.26923076923077 175.08974358974359 141.80769230769232 119.24358974358974];
    objmask = poly2mask(poly_x, poly_y, size(im_obj, 1), size(im_obj, 2));

    center_x = 758.96703296703311;
    bottom_y = 351.33699633699609;
    padding = 64;
    validate_image_set_geometry(im_bg, im_obj, objmask, poly_x, poly_y, ...
        center_x, bottom_y, padding, sets(4));
    [im_s, mask_s] = alignSource(im_obj, objmask, im_bg, ...
        center_x, bottom_y, padding);
    mask_s = im2double(mask_s);

    levels = 6;
    result4 = laplacian_blend(im_bg, im_s, mask_s, levels);
    completed_sets(end + 1) = 4;

    result_display = min(max(result4, 0), 1);
    if show_figures
        mask_rgb = repmat(mask_s, [1 1 3]);
        figure('Name', sprintf('Result 4 - %s', method_name), ...
            'NumberTitle', 'off');
        montage({im_bg, im_obj, mask_rgb, result_display}, 'Size', [2 2]);
        title(sprintf('Result 4: %s | %s', sets(4).name, method_name), ...
            'Interpreter', 'none');
    end
    if write_outputs
        imwrite(result_display, fullfile(output_folder, 'result4.png'));
    end
    fprintf('Computed result4: %s (%s).\n', sets(4).name, method_name);
else
    warning('Assignment:PendingImageSet', ...
        'result4 has no saved selection (%s).', ...
        sets(4).name);
end

if sets(5).ready
    im_bg = read_assignment_image(root_folder, 'images/set5_background.png');
    im_obj = read_assignment_image(root_folder, 'images/set5_source.png');

    poly_x = [749.95054945054926 770.46336996336981 785.11538461538453 796.83699633699621 ...
        798.30219780219772 824.67582417582412 859.84065934065916 862.77106227106219 ...
        875.95787545787539 897.93589743589746 916.98351648351638 937.49633699633682 ...
        952.14835164835142 963.8699633699631 959.47435897435889 947.75274725274721 ...
        919.9139194139193 915.51831501831498 925.77472527472514 925.77472527472514 ...
        899.40109890109875 915.51831501831498 930.17032967032935 943.35714285714266 ...
        955.07875457875457 968.26556776556765 969.73076923076894 987.3131868131868 ...
        1009.2912087912085 1018.0824175824175 1012.2216117216117 996.10439560439545 ...
        981.45238095238096 960.93956043956041 938.96153846153834 911.12271062271043 ...
        890.6098901098901 884.74908424908426 881.81868131868123 858.37545787545787 ...
        842.25824175824164 832.00183150183136 823.2106227106226 811.48901098901092 ...
        793.9065934065934 767.53296703296701 752.88095238095229 736.76373626373629 ...
        723.57692307692309 708.92490842490838 684.0164835164835 664.96886446886447 ...
        653.24725274725279 647.38644688644672 651.78205128205127 664.96886446886447 ...
        686.94688644688631 705.99450549450535 705.99450549450535 714.78571428571422 ...
        726.5073260073259 735.29853479853477 744.08974358974342 745.55494505494494 ...
        761.67216117216117 763.13736263736246 758.74175824175813 735.29853479853477 ...
        714.78571428571422 705.99450549450535 704.52930402930406 714.78571428571422 ...
        730.90293040293022];
    poly_y = [128.70512820512818 130.17032967032969 141.89194139194137 159.47435897435892 ...
        177.05677655677653 168.26556776556777 169.73076923076928 143.35714285714289 ...
        121.37912087912082 115.51831501831498 116.9835164835165 133.1007326007325 ...
        155.07875457875457 182.91758241758237 203.43040293040292 218.08241758241752 ...
        225.40842490842488 240.06043956043956 266.43406593406598 297.2032967032967 ...
        319.18131868131866 345.55494505494494 376.32417582417577 367.53296703296701 ...
        358.74175824175808 363.13736263736257 374.85897435897436 388.04578754578756 ...
        410.02380952380952 429.07142857142856 442.2582417582417 449.584249084249 ...
        471.56227106227107 489.14468864468859 495.00549450549443 495.00549450549443 ...
        490.6098901098901 480.35347985347983 462.77106227106214 451.04945054945046 ...
        455.44505494505495 462.77106227106214 484.74908424908415 493.54029304029302 ...
        490.6098901098901 486.21428571428567 477.42307692307691 464.23626373626371 ...
        445.18864468864462 451.04945054945046 445.18864468864462 436.3974358974358 ...
        420.28021978021968 407.0934065934066 392.44139194139188 383.65018315018312 ...
        376.32417582417577 374.85897435897436 370.46336996336993 366.06776556776549 ...
        370.46336996336993 379.25457875457869 374.85897435897436 349.95054945054949 ...
        326.5073260073259 279.62087912087907 238.59523809523807 235.66483516483515 ...
        225.40842490842488 204.89560439560432 181.45238095238096 152.14835164835176 ...
        137.49633699633705];
    objmask = poly2mask(poly_x, poly_y, size(im_obj, 1), size(im_obj, 2));

    center_x = 519.9139194139193;
    bottom_y = 732.36813186813185;
    padding = 64;
    validate_image_set_geometry(im_bg, im_obj, objmask, poly_x, poly_y, ...
        center_x, bottom_y, padding, sets(5));
    [im_s, mask_s] = alignSource(im_obj, objmask, im_bg, ...
        center_x, bottom_y, padding);
    mask_s = im2double(mask_s);

    levels = 6;
    result5 = laplacian_blend(im_bg, im_s, mask_s, levels);
    completed_sets(end + 1) = 5;

    result_display = min(max(result5, 0), 1);
    if show_figures
        mask_rgb = repmat(mask_s, [1 1 3]);
        figure('Name', sprintf('Result 5 - %s', method_name), ...
            'NumberTitle', 'off');
        montage({im_bg, im_obj, mask_rgb, result_display}, 'Size', [2 2]);
        title(sprintf('Result 5: %s | %s', sets(5).name, method_name), ...
            'Interpreter', 'none');
    end
    if write_outputs
        imwrite(result_display, fullfile(output_folder, 'result5.png'));
    end
    fprintf('Computed result5: %s (%s).\n', sets(5).name, method_name);
else
    warning('Assignment:PendingImageSet', ...
        'result5 has no saved selection (%s).', ...
        sets(5).name);
end


configuration = sets;
if write_outputs
    save(fullfile(output_folder, 'results.mat'), ...
        'result1', 'result2', 'result3', 'result4', 'result5', ...
        'sets', 'completed_sets', 'configuration', 'method_name');
end


function im_blend = laplacian_blend(im_bg, im_s, mask_s, levels)

    validateattributes(im_bg, {'numeric', 'logical'}, ...
        {'nonempty', 'real', 'nonsparse', 'finite'}, mfilename, 'im_bg', 1);
    validateattributes(im_s, {'numeric', 'logical'}, ...
        {'nonempty', 'real', 'nonsparse', 'finite'}, mfilename, 'im_s', 2);
    validateattributes(mask_s, {'numeric', 'logical'}, ...
        {'nonempty', 'real', 'nonsparse', 'finite', '2d'}, ...
        mfilename, 'mask_s', 3);
    validateattributes(levels, {'numeric'}, ...
        {'scalar', 'real', 'finite', 'integer', 'positive'}, ...
        mfilename, 'levels', 4);
    if ndims(im_bg) > 3 || ~ismember(size(im_bg, 3), [1, 3])
        error('laplacian_blend:ImageShape', ...
            'Images must be grayscale H-by-W or RGB H-by-W-by-3.');
    end
    if ~isequal(size(im_bg), size(im_s))
        error('laplacian_blend:ImageSize', ...
            'The background and aligned source must have identical sizes.');
    end
    if ~isequal(size(mask_s), [size(im_bg, 1), size(im_bg, 2)])
        error('laplacian_blend:MaskSize', ...
            'The mask must match the image height and width.');
    end

    im_bg = im2double(im_bg);
    im_s = im2double(im_s);
    mask_s = im2double(mask_s);
    levels = double(levels);
    if any(mask_s(:) < 0) || any(mask_s(:) > 1)
        error('laplacian_blend:MaskRange', 'Mask values must lie in [0, 1].');
    end

    pyr_M = pyr_gaussian(mask_s, levels);
    pyr_S = pyr_laplacian(im_s, levels);
    pyr_B = pyr_laplacian(im_bg, levels);
    pyr_blend = cell(levels, 1);

    for i = 1:levels
        pyr_blend{i} = bsxfun(@times, pyr_S{i}, pyr_M{i}) + ...
                       bsxfun(@times, pyr_B{i}, 1 - pyr_M{i});
    end

    im_blend = pyr_laplacian_collapse(pyr_blend);
end


function pyr_G = pyr_gaussian(im, levels)

    validateattributes(im, {'numeric', 'logical'}, ...
        {'nonempty', 'real', 'nonsparse', 'finite'}, mfilename, 'im', 1);
    validateattributes(levels, {'numeric'}, ...
        {'scalar', 'real', 'finite', 'integer', 'positive'}, ...
        mfilename, 'levels', 2);
    if ndims(im) > 3 || ~ismember(size(im, 3), [1, 3])
        error('pyr_gaussian:ImageShape', ...
            'The input must be grayscale H-by-W or RGB H-by-W-by-3.');
    end

    levels = double(levels);
    pyr_G = cell(levels, 1);
    pyr_G{1} = im2double(im);

    for i = 2:levels
        pyr_G{i} = imresize(imgaussfilt(pyr_G{i - 1}, 2), 0.5);
    end
end


function pyr_L = pyr_laplacian(im, levels)

    pyr_G = pyr_gaussian(im, levels);
    levels = numel(pyr_G);
    pyr_L = cell(levels, 1);

    pyr_L{levels} = pyr_G{levels};

    for i = levels - 1:-1:1
        target_size = [size(pyr_G{i}, 1), size(pyr_G{i}, 2)];
        expanded = imresize(pyr_G{i + 1}, target_size);
        pyr_L{i} = pyr_G{i} - expanded;
    end
end


function im = pyr_laplacian_collapse(pyr)

    if ~iscell(pyr) || isempty(pyr) || ~isvector(pyr)
        error('pyr_laplacian_collapse:PyramidType', ...
            'The pyramid must be a nonempty cell vector.');
    end
    levels = numel(pyr);

    channels = size(pyr{1}, 3);
    for i = 1:levels
        validateattributes(pyr{i}, {'numeric', 'logical'}, ...
            {'nonempty', 'real', 'nonsparse', 'finite'}, ...
            mfilename, sprintf('pyr{%d}', i));
        if ndims(pyr{i}) > 3 || ~ismember(size(pyr{i}, 3), [1, 3]) || ...
                size(pyr{i}, 3) ~= channels
            error('pyr_laplacian_collapse:LevelShape', ...
                'All levels must be grayscale or RGB with matching channels.');
        end
        if i > 1 && (size(pyr{i}, 1) > size(pyr{i - 1}, 1) || ...
                     size(pyr{i}, 2) > size(pyr{i - 1}, 2))
            error('pyr_laplacian_collapse:LevelOrder', ...
                'Spatial sizes must not increase from fine to coarse levels.');
        end
    end

    im = double(pyr{levels});
    for i = levels - 1:-1:1
        target_size = [size(pyr{i}, 1), size(pyr{i}, 2)];
        im = double(pyr{i}) + imresize(im, target_size);
    end
end


function display_gaussian(pyr)
    figure; montage(pyr);
end

function display_laplacian(pyr)
    for i = 1:numel(pyr) - 1
        pyr{i} = pyr{i} + 0.5;
    end
    figure; montage(pyr);
end
function sets = assignment_image_sets()
sets = repmat(struct(), 1, 5);

sets(1).name = 'Bear in the swimming pool';
sets(1).background = 'images/swim.jpg';
sets(1).source = 'images/bear.jpg';
    sets(1).poly_x = [276.4628 324.9961 391.5884 425.4488 ...
        453.6659 457.0519 433.3496 442.3791 ...
        441.2504 348.6984 248.2457 222.2860 ...
        238.0876 226.8008 222.2860 214.3853 ...
        224.5434 248.2457];
    sets(1).poly_y = [255.3512 238.4209 255.3512 250.8364 ...
        260.9946 283.5682 329.8442 349.0318 ...
        404.3372 419.0101 404.3372 356.9326 ...
        342.2597 308.3992 292.5977 265.5093 ...
        250.8364 247.4504];
sets(1).center_x = 575.92639999999994;
sets(1).bottom_y = 432.49220000000003;
sets(1).padding = 64;
sets(1).blur = 16;
sets(1).levels = 6;
sets(1).ready = logical(true);
sets(1).source_size = [];
sets(1).background_size = [];
sets(1).source_url = 'https://www.cs.unc.edu/~montek/teaching/Comp541-Fall20/Comp572/bear.jpg';
sets(1).background_url = 'https://www.cs.unc.edu/~montek/teaching/Comp541-Fall20/Comp572/swim.jpg';
sets(1).source_credit = 'Instructor-provided bear image';
sets(1).background_credit = 'Instructor-provided swimmers image';

sets(2).name = 'Orapple';
sets(2).background = 'images/set2_background.jpg';
sets(2).source = 'images/set2_source.jpg';
    sets(2).poly_x = [363.19047619047632 413.78754578754587 467.04761904761909 520.30769230769238 ...
        560.25274725274721 588.65811965811963 607.29914529914527 610.84981684981699 ...
        604.6361416361417 583.33211233211227 546.93772893772893 500.77899877899887 ...
        447.51892551892547 387.15750915750925 363.19047619047632];
    sets(2).poly_y = [107.46398046398053 107.46398046398053 123.44200244200249 153.62271062271066 ...
        198.89377289377296 248.60317460317464 307.18925518925522 366.66300366300374 ...
        427.02442002442007 480.28449328449335 528.21855921855922 562.83760683760693 ...
        586.80463980463981 598.34432234432234 598.34432234432234];
sets(2).center_x = 570.28021978021968;
sets(2).bottom_y = 573.02747252747258;
sets(2).padding = 64;
sets(2).blur = 12;
sets(2).levels = 6;
sets(2).ready = logical(true);
sets(2).source_size = [727 760 3];
sets(2).background_size = [600 900 3];
sets(2).source_url = 'https://commons.wikimedia.org/wiki/File:Orange_sliced_on_white_background.jpg';
sets(2).background_url = 'https://commons.wikimedia.org/wiki/File:Apple_(1).jpg';
sets(2).source_credit = 'Orange: Paolo Neo, public domain, Wikimedia Commons';
sets(2).background_credit = 'Apple: Renee Comet / National Cancer Institute, public domain';

sets(3).name = 'Eye in a hand';
sets(3).background = 'images/set3_background.jpg';
sets(3).source = 'images/set3_source.jpg';
    sets(3).poly_x = [133.42307692307696 175.26923076923083 239.88461538461542 304.5 ...
        369.11538461538464 415.26923076923083 433.73076923076928 406.03846153846155 ...
        341.42307692307691 253.42307692307696 175.26923076923083 130.96153846153851];
    sets(3).poly_y = [274.65384615384613 221.11538461538458 189.11538461538458 187.88461538461536 ...
        200.80769230769226 245.11538461538458 287.57692307692304 329.42307692307691 ...
        355.26923076923077 355.26923076923077 334.96153846153845 305.42307692307691];
sets(3).center_x = 741.13369963369962;
sets(3).bottom_y = 630.60622710622715;
sets(3).padding = 64;
sets(3).blur = 6;
sets(3).levels = 6;
sets(3).ready = logical(true);
sets(3).source_size = [504 552 3];
sets(3).background_size = [1074 1000 3];
sets(3).source_url = 'https://commons.wikimedia.org/wiki/File:Close_up_shot_of_the_human_eye,_9_August_2024.jpg';
sets(3).background_url = 'https://commons.wikimedia.org/wiki/File:Crawling_hand.png';
sets(3).source_credit = 'Eye: Kookaaa, CC0, Wikimedia Commons';
sets(3).background_credit = 'Hand: Spaniel, public domain, Wikimedia Commons';

sets(4).name = 'Moon over a landscape';
sets(4).background = 'images/set4_background.jpg';
sets(4).source = 'images/set4_source.jpg';
    sets(4).poly_x = [234.73076923076914 274.78205128205116 310.88461538461524 334.01282051282044 ...
        343.03846153846143 334.57692307692298 310.88461538461524 275.3461538461537 ...
        234.73076923076914 193.55128205128199 159.70512820512818 136.0128205128205 ...
        126.42307692307689 134.88461538461536 158.57692307692304 195.24358974358967];
    sets(4).poly_y = [110.78205128205127 119.24358974358974 141.80769230769232 176.78205128205127 ...
        216.26923076923077 256.88461538461536 291.85897435897431 313.85897435897431 ...
        322.88461538461536 314.42307692307691 291.85897435897431 256.88461538461536 ...
        216.26923076923077 175.08974358974359 141.80769230769232 119.24358974358974];
sets(4).center_x = 758.96703296703311;
sets(4).bottom_y = 351.33699633699609;
sets(4).padding = 64;
sets(4).blur = 16;
sets(4).levels = 6;
sets(4).ready = logical(true);
sets(4).source_size = [462 460 3];
sets(4).background_size = [859 960 3];
sets(4).source_url = 'https://commons.wikimedia.org/wiki/File:AS11-44-6667_-_Full_Moon_Photographed_From_Apollo_11_Spacecraft.jpg';
sets(4).background_url = 'https://commons.wikimedia.org/wiki/File:Night_Sky_-_Boney_Mountain_%26_Milky_Way_(11074300594).jpg';
sets(4).source_credit = 'Moon: NASA / Apollo 11, AS11-44-6667, public domain';
sets(4).background_credit = 'Night landscape: Santa Monica Mountains National Recreation Area / National Park Service, public domain';

sets(5).name = 'Mickey plush on a different couch';
sets(5).background = 'images/set5_background.png';
sets(5).source = 'images/set5_source.png';
    sets(5).poly_x = [749.95054945054926 770.46336996336981 785.11538461538453 796.83699633699621 ...
        798.30219780219772 824.67582417582412 859.84065934065916 862.77106227106219 ...
        875.95787545787539 897.93589743589746 916.98351648351638 937.49633699633682 ...
        952.14835164835142 963.8699633699631 959.47435897435889 947.75274725274721 ...
        919.9139194139193 915.51831501831498 925.77472527472514 925.77472527472514 ...
        899.40109890109875 915.51831501831498 930.17032967032935 943.35714285714266 ...
        955.07875457875457 968.26556776556765 969.73076923076894 987.3131868131868 ...
        1009.2912087912085 1018.0824175824175 1012.2216117216117 996.10439560439545 ...
        981.45238095238096 960.93956043956041 938.96153846153834 911.12271062271043 ...
        890.6098901098901 884.74908424908426 881.81868131868123 858.37545787545787 ...
        842.25824175824164 832.00183150183136 823.2106227106226 811.48901098901092 ...
        793.9065934065934 767.53296703296701 752.88095238095229 736.76373626373629 ...
        723.57692307692309 708.92490842490838 684.0164835164835 664.96886446886447 ...
        653.24725274725279 647.38644688644672 651.78205128205127 664.96886446886447 ...
        686.94688644688631 705.99450549450535 705.99450549450535 714.78571428571422 ...
        726.5073260073259 735.29853479853477 744.08974358974342 745.55494505494494 ...
        761.67216117216117 763.13736263736246 758.74175824175813 735.29853479853477 ...
        714.78571428571422 705.99450549450535 704.52930402930406 714.78571428571422 ...
        730.90293040293022];
    sets(5).poly_y = [128.70512820512818 130.17032967032969 141.89194139194137 159.47435897435892 ...
        177.05677655677653 168.26556776556777 169.73076923076928 143.35714285714289 ...
        121.37912087912082 115.51831501831498 116.9835164835165 133.1007326007325 ...
        155.07875457875457 182.91758241758237 203.43040293040292 218.08241758241752 ...
        225.40842490842488 240.06043956043956 266.43406593406598 297.2032967032967 ...
        319.18131868131866 345.55494505494494 376.32417582417577 367.53296703296701 ...
        358.74175824175808 363.13736263736257 374.85897435897436 388.04578754578756 ...
        410.02380952380952 429.07142857142856 442.2582417582417 449.584249084249 ...
        471.56227106227107 489.14468864468859 495.00549450549443 495.00549450549443 ...
        490.6098901098901 480.35347985347983 462.77106227106214 451.04945054945046 ...
        455.44505494505495 462.77106227106214 484.74908424908415 493.54029304029302 ...
        490.6098901098901 486.21428571428567 477.42307692307691 464.23626373626371 ...
        445.18864468864462 451.04945054945046 445.18864468864462 436.3974358974358 ...
        420.28021978021968 407.0934065934066 392.44139194139188 383.65018315018312 ...
        376.32417582417577 374.85897435897436 370.46336996336993 366.06776556776549 ...
        370.46336996336993 379.25457875457869 374.85897435897436 349.95054945054949 ...
        326.5073260073259 279.62087912087907 238.59523809523807 235.66483516483515 ...
        225.40842490842488 204.89560439560432 181.45238095238096 152.14835164835176 ...
        137.49633699633705];
sets(5).center_x = 519.9139194139193;
sets(5).bottom_y = 732.36813186813185;
sets(5).padding = 64;
sets(5).blur = 12;
sets(5).levels = 6;
sets(5).ready = logical(true);
sets(5).source_size = [1200 1600 3];
sets(5).background_size = [1200 1600 3];
sets(5).source_url = 'https://raw.githubusercontent.com/akksharvan/COMP-572/main/Assignments/Assignment%2005/images/set5_source.png';
sets(5).background_url = 'https://raw.githubusercontent.com/akksharvan/COMP-572/main/Assignments/Assignment%2005/images/set5_background.png';
sets(5).source_credit = 'Taken by me: IMG_1636.HEIC, Mickey plush on a couch';
sets(5).background_credit = 'Taken by me: IMG_1637.HEIC, a different couch';
end
function validate_image_set_geometry(im_bg, im_obj, objmask, poly_x, poly_y, ...
        center_x, bottom_y, padding, item)
    if ~isempty(item.source_size)
        assert(isequal(size(im_obj), item.source_size), ...
            'Assignment:ChangedSource', 'Source dimensions changed for %s.', item.name);
    end
    if ~isempty(item.background_size)
        assert(isequal(size(im_bg), item.background_size), ...
            'Assignment:ChangedBackground', 'Background dimensions changed for %s.', item.name);
    end
    validateattributes(poly_x, {'double'}, {'vector', 'finite'});
    validateattributes(poly_y, {'double'}, {'vector', 'finite'});
    assert(numel(poly_x) >= 3 && numel(poly_x) == numel(poly_y), ...
        'Assignment:Polygon', 'A polygon needs at least three paired vertices.');
    validateattributes(center_x, {'double'}, {'scalar', 'finite'});
    validateattributes(bottom_y, {'double'}, {'scalar', 'finite'});
    validateattributes(padding, {'numeric'}, {'scalar', 'integer', 'nonnegative'});
    [y, x] = find(objmask);
    assert(~isempty(y), 'Assignment:EmptyMask', ...
        'The polygon does not cover any source pixels.');
    target_y = y - max(y) + round(bottom_y);
    target_x = x - round(mean(x)) + round(center_x);
    assert(all(target_y >= 1 & target_y <= size(im_bg, 1)) && ...
        all(target_x >= 1 & target_x <= size(im_bg, 2)), ...
        'Assignment:ObjectOutsideBackground', ...
        'Place the entire object inside the background for %s.', item.name);
end
function im = read_assignment_image(root_folder, relative_path)

image_path = fullfile(root_folder, relative_path);
if ~isfile(image_path)
    [~, name, extension] = fileparts(relative_path);
    image_path = fullfile(root_folder, [name extension]);
end
if ~isfile(image_path)
    [~, name, extension] = fileparts(relative_path);
    image_path = fullfile(root_folder, relative_path);
    image_folder = fileparts(image_path);
    image_url = ['https://raw.githubusercontent.com/akksharvan/' ...
        'COMP-572/main/Assignments/Assignment%2005/images/' name extension];
    temporary_path = '';
    try
        if ~isfolder(image_folder)
            mkdir(image_folder);
        end
        temporary_path = [tempname(image_folder) extension];
        websave(temporary_path, image_url, weboptions('Timeout', 30));
        [moved, message] = movefile(temporary_path, image_path, 'f');
        if ~moved
            error('Assignment:ImageCache', '%s', message);
        end
    catch download_error
        if ~isempty(temporary_path) && isfile(temporary_path)
            delete(temporary_path);
        end
        error('Assignment:ImageDownload', ...
            'Image %s is missing locally and could not be downloaded from %s: %s', ...
            relative_path, image_url, download_error.message);
    end
end
[pixels, map] = imread(image_path);
if isempty(map)
    im = im2double(pixels);
else
    im = ind2rgb(pixels, map);
end

if size(im, 3) == 1
    im = repmat(im, [1 1 3]);
end
assert(size(im, 3) == 3, 'Assignment:ColorChannels', ...
    'Choose a grayscale or RGB image: %s', relative_path);
end


function [im_s2, mask2] = alignSource(im_s, mask, im_t, center_x, bottom_y, padding)

    [y, x] = find(mask);
    y1 = min(y)-1-padding; y2 = max(y)+1+padding;
    x1 = min(x)-1-padding; x2 = max(x)+1+padding;
    im_s2 = zeros(size(im_t));

    yind = (y1:y2);
    yind2 = yind - max(y) + round(bottom_y);
    xind = (x1:x2);
    xind2 = xind - round(mean(x)) + round(center_x);

    yind(yind > size(im_s, 1)) = size(im_s, 1);
    yind(yind < 1) = 1;
    xind(xind > size(im_s, 2)) = size(im_s, 2);
    xind(xind < 1) = 1;
    yind2(yind2 > size(im_t, 1)) = size(im_t, 1);
    yind2(yind2 < 1) = 1;
    xind2(xind2 > size(im_t, 2)) = size(im_t, 2);
    xind2(xind2 < 1) = 1;

    y = y - max(y) + round(bottom_y);
    x = x - round(mean(x)) + round(center_x);
    ind = y + (x-1)*size(im_t, 1);
    mask2 = false(size(im_t, 1), size(im_t, 2));
    mask2(ind) = true;
    im_s2(yind2, xind2, :) = im_s(yind, xind, :);
end

