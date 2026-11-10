%% COMP 572 Assignment 08 | Synthetic Bokeh
%{
AI Usage Report
1. AI tool used: OpenAI Codex.
2. Example prompts: "Similar to the previous assignments, complete
   Assignment 08." and "For any user generated photos, tell me exactly
   what to photograph to best demonstrate the effect of the filter."
3. Codex wrote Method 3 and the image-processing script around the
   instructor's two reference methods. It selected and prepared the
   public-source examples, traced the polygons, cropped and adjusted my personal photo,
   and verified the results.
4. I arranged and photographed the backpack scene (IMG_1730.HEIC).
   Codex performed the MATLAB debugging and tuning for this version.
%}
%{
Results
The couple comparison shows color bleed in Method 1 and a dark rim in Method 2.
Method 3 preserves the woman's detail while smoothing the face behind her.
The astronaut's suit and the tabby's fur stay crisp against softer backgrounds.
The hydrant's shadow and fine petal tips can still reveal the mask boundary.
The backpack's stitching, logo, and straps stay sharp as the chair mesh softens.
%}

close('all');
% MATLAB Grader loads the prepared images from this folder when needed.
repository_images = ['https://raw.githubusercontent.com/akksharvan/COMP-572/main/' ...
    'Assignments/Assignment%2008%20-%20Synthetic%20Bokeh/images/'];
root = fileparts(mfilename('fullpath'));
local_images = fullfile(root, 'images');
write_results = isfolder(local_images);
output_dir = fullfile(root, 'results');
if write_results && ~isfolder(output_dir)
    mkdir(output_dir);
end

files = {'couple.png', 'astronaut.png', 'tabby.png', 'hydrant.png', ...
    'sunflower.png', 'personal_backpack.png'};
subjects = {'Course example', 'Eileen Collins', 'Tabby cat', ...
    'Red hydrant', 'Sunflower', 'CSXL backpack'};
radius = [15, 19, 23, 26, 21, 22];

% Image 1: course starter. Local copies come from the assignment handout.
% Image 2: NASA, Eileen Collins, https://flic.kr/p/r9qvLn (public domain).
% Image 3: Alvesgaspar, https://commons.wikimedia.org/wiki/File:Cat_November_2010-1a.jpg
% CC BY-SA 3.0, https://creativecommons.org/licenses/by-sa/3.0/
% Image 4: Daniel Case, red hydrant, https://commons.wikimedia.org/wiki/File:Red_fire_hydrant,_shadow,_sidewalk_and_wall.jpg
% CC BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/
% Image 5: Don McCulley, https://commons.wikimedia.org/wiki/File:Sunflower_Public_Domain.jpg
% CC0, https://creativecommons.org/publicdomain/zero/1.0/
% Image 6: my own phone photo IMG_1730.HEIC, taken in the CSXL at UNC Chapel Hill.

% Foreground outlines as [x y] pairs on the prepared images (one-based).
% These are fixed so that the submitted script runs without mouse input.
vertices = cell(1, 6);
vertices{2} = [
    50 513; 40 497; 33 483; 27 470; 24 455; 23 433; 21 419;
    19 404; 21 392; 24 379; 26 366; 26 344; 28 326; 34 309;
    40 294; 47 282; 55 270; 67 250; 78 238; 94 225; 106 214;
    113 205; 114 192; 117 187; 123 188; 125 176; 133 165;
    144 156; 158 151; 172 149; 184 149; 183 138; 179 129;
    174 119; 167 115; 162 109; 157 100; 155 93; 153 82;
    153 72; 155 63; 159 56; 166 50; 174 44; 183 39;
    190 32; 203 28; 218 23; 230 18; 240 17; 250 19;
    262 23; 273 28; 282 34; 288 41; 293 50; 297 62;
    299 73; 302 84; 302 94; 299 105; 294 115; 288 121;
    282 126; 274 130; 265 131; 263 142; 260 151; 257 164;
    256 177; 267 185; 277 194; 286 202; 294 212; 301 225;
    305 235; 316 242; 331 249; 340 259; 345 270; 352 282;
    357 297; 360 314; 362 334; 363 343; 366 351; 382 346;
    397 344; 412 345; 426 348; 441 353; 455 360; 466 369;
    478 381; 488 396; 494 409; 498 425; 499 442; 500 456;
    505 457; 512 470; 513 478; 513 513
];
vertices{3} = [
    201 155; 204 131; 207 119; 218 118; 232 122; 247 132;
    261 143; 275 158; 286 168; 310 166; 335 166; 352 171;
    364 158; 378 144; 394 132; 410 125; 424 122; 429 135;
    434 157; 436 179; 435 199; 429 222; 427 235; 432 250;
    436 272; 436 288; 431 307; 425 328; 420 347; 421 367;
    429 390; 438 406; 451 419; 470 431; 497 441; 521 451;
    548 466; 573 485; 596 504; 619 524; 640 550; 654 576;
    667 600; 678 629; 687 663; 692 698; 696 730; 698 781;
    275 781; 270 763; 260 734; 249 710; 241 685; 232 668;
    219 643; 214 624; 203 603; 195 576; 187 549; 180 526;
    175 506; 170 485; 165 461; 163 437; 166 410; 174 388;
    182 368; 190 350; 195 332; 198 309; 199 286; 202 265;
    206 241; 213 220; 209 208; 205 190; 203 171
];
vertices{4} = [
    223 83; 223 56; 227 51; 235 48; 243 48; 249 51; 250 80;
    254 84; 264 87; 265 99; 271 102; 276 110; 279 124;
    280 137; 295 148; 302 158; 309 168; 316 181; 321 201;
    326 206; 334 207; 338 214; 354 220; 361 225; 363 236;
    362 254; 358 262; 346 268; 345 274; 338 282; 324 285;
    323 313; 326 330; 325 350; 329 359; 342 371; 350 389;
    352 408; 347 424; 343 437; 333 445; 323 450; 321 474;
    316 489; 313 510; 310 539; 310 548; 315 556; 317 572;
    314 599; 310 623; 304 632; 288 642; 262 647; 229 647;
    202 644; 179 641; 155 630; 149 616; 146 595; 146 564;
    149 543; 149 521; 144 509; 137 502; 133 488; 133 476;
    137 463; 136 450; 139 436; 141 421; 124 421; 115 413;
    111 414; 105 424; 93 427; 82 424; 77 417; 57 412;
    49 402; 43 387; 39 378; 17 376; 15 370; 16 360;
    21 354; 42 352; 46 339; 54 335; 61 326; 75 321;
    99 315; 120 314; 126 310; 143 310; 147 303; 147 281;
    137 279; 132 267; 119 266; 109 261; 106 250; 104 234;
    106 225; 115 220; 128 215; 146 211; 149 195; 157 180;
    168 165; 177 156; 180 144; 187 139; 193 137; 194 118;
    196 111; 202 106; 209 102; 212 93; 220 91
];
vertices{5} = [
    284 540.5; 272.5 528; 263 501.5; 256.5 518; 249 527.5; 243 531.5;
    237.5 524; 239.5 522; 237 521.5; 233.5 516; 232.5 504; 228.5 499;
    229.5 491; 226 486.5; 225 488.5; 223.5 487; 224.5 484; 220 478.5;
    217.5 480; 210.5 497; 212 500.5; 214.5 500; 211 507.5; 202 504.5;
    199.5 501; 200.5 494; 206.5 489; 201.5 486; 202 476.5; 196.5 477;
    192.5 488; 183 496.5; 171 499.5; 163 506.5; 157.5 506; 155.5 501;
    157.5 474; 162.5 469; 163.5 464; 161.5 460; 159 459.5; 155.5 470;
    152 471.5; 151 474.5; 149.5 473; 145.5 462; 146.5 436; 126 441.5;
    104 442.5; 102.5 441; 105.5 438; 107.5 411; 114.5 396; 139 369.5;
    159 354.5; 168.5 350; 151 345.5; 115 360.5; 102 360.5; 93 356.5;
    86.5 348; 89.5 342; 111 322.5; 119.5 318; 100 314.5; 81 307.5;
    66.5 296; 64.5 288; 72 282.5; 97.5 274; 83.5 255; 83.5 252;
    93 243.5; 109 235.5; 134 229.5; 148.5 229; 140.5 212; 139.5 202;
    131.5 183; 131.5 175; 134 173.5; 151 178.5; 164.5 178; 160.5 165;
    159.5 150; 169.5 148; 165.5 143; 167 135.5; 172 133.5; 181 134.5;
    210 145.5; 208.5 129; 210.5 119; 217.5 102; 222 97.5; 231 98.5;
    254 113.5; 258.5 96; 270 81.5; 276 83.5; 295 100.5; 296.5 90;
    303.5 71; 302.5 66; 305 64.5; 313.5 72; 324 89.5; 337 73.5;
    346 69.5; 359 95.5; 362 92.5; 366 94.5; 369.5 82; 381 75.5;
    389.5 98; 389 116.5; 402 102.5; 410 98.5; 418 100.5; 427.5 126;
    427.5 149; 425 161.5; 438 147.5; 453 138.5; 460.5 140; 451 150.5;
    482 148.5; 484.5 150; 483 156.5; 494 154.5; 515 156.5; 514.5 160;
    503.5 174; 484.5 191; 499 189.5; 515 191.5; 527 194.5; 534.5 200;
    532.5 210; 524.5 225; 503.5 245; 535 250.5; 551.5 261; 538.5 268;
    547.5 277; 547.5 281; 539.5 287; 551.5 299; 545 303.5; 536.5 303;
    545.5 310; 549.5 316; 540 324.5; 524.5 333; 534.5 343; 539 352.5;
    543.5 350; 548.5 360; 529 366.5; 500.5 369; 500.5 379; 522.5 400;
    524 406.5; 517 398.5; 492 384.5; 502.5 405; 502.5 412; 481 405.5;
    478.5 408; 497.5 428; 486 434.5; 473 433.5; 465 434.5; 460 439.5;
    453 438.5; 449.5 442; 458.5 454; 459 458.5; 450 460.5; 431 458.5;
    429.5 462; 427 462.5; 413 459.5; 401 453.5; 395 459.5; 382 446.5;
    373.5 455; 371.5 462; 364.5 472; 351.5 482; 350 487.5; 347.5 487;
    344 480.5; 341.5 481; 328 505.5; 313 492.5; 301.5 521; 293.5 519;
];
vertices{6} = [
    26 669; 28 654; 36 640; 49 628; 65 618; 69 615;
    64 600; 60 575; 58 546; 54 514; 51 484; 48 451;
    46 415; 43 383; 41 349; 43 324; 42 314; 36 305;
    34 295; 38 285; 33 277; 32 268; 34 260; 40 250;
    44 246; 42 235; 42 224; 40 205; 40 196; 47 185;
    54 175; 66 160; 73 145; 84 133; 97 121; 112 111;
    133 101; 154 92; 174 85; 195 78; 213 72; 228 67;
    225 61; 224 55; 233 51; 246 47; 262 45; 266 49;
    272 51; 295 46; 318 43; 344 42; 367 42; 393 44;
    417 50; 434 55; 445 61; 459 72; 465 81; 474 95;
    478 106; 478 114; 486 119; 494 130; 501 141; 505 150;
    509 158; 507 163; 516 170; 521 178; 521 187; 525 198;
    530 213; 533 230; 536 249; 540 267; 542 284; 541 302;
    544 321; 552 343; 556 364; 562 384; 567 409; 573 431;
    575 451; 579 471; 588 485; 604 497; 622 512; 639 530;
    652 547; 666 564; 680 582; 687 589; 695 594; 694 599;
    690 604; 696 615; 704 616; 712 619; 712 627; 716 638;
    721 651; 727 667; 735 683; 742 699; 749 715; 758 731;
    765 747; 771 763; 776 779; 781 795; 785 811; 790 827;
    794 843; 798 859; 802 875; 805 891; 808 907; 811 923;
    813 941; 757 941; 755 922; 752 899; 749 874; 746 852;
    742 830; 737 809; 731 787; 724 764; 716 740; 707 715;
    697 689; 687 669; 680 649; 673 643; 664 639; 657 642;
    646 635; 633 631; 615 629; 601 628; 586 629; 582 646;
    573 667; 564 687; 551 704; 536 719; 513 734; 489 744;
    462 751; 437 755; 406 759; 372 763; 339 765; 303 765;
    268 763; 239 757; 217 749; 198 738; 177 725; 158 716;
    140 715; 125 707; 117 704; 107 711; 93 716; 76 718;
    60 715; 49 710; 40 700; 33 688; 28 677
];
% The chair seen through the left strap loop is background.
strap_opening = [
    33 661; 36 650; 43 642; 53 637; 64 632; 73 631;
    75 640; 75 655; 74 673; 75 685; 79 690; 66 690;
    55 687; 45 682; 39 675; 35 668
];

results = cell(1, numel(files));
for n = 1:numel(files)
    I = im2double(readInput(files{n}, local_images, repository_images));
    kernel = fspecial('disk', radius(n));
    if n == 1
        mask = readInput('mask.png', local_images, repository_images);
        mask = im2double(mask(:,:,1)) > 0.5;
        result1a = method1(I, mask, kernel);
        result1b = method2(I, mask, kernel);
    else
        xy = vertices{n};
        mask = poly2mask(xy(:,1), xy(:,2), size(I,1), size(I,2));
        if n == 6 && ~isempty(strap_opening)
            mask = mask & ~poly2mask(strap_opening(:,1), strap_opening(:,2), ...
                size(I,1), size(I,2));
        end
    end
    result = method3(I, mask, kernel);
    results{n} = result;

    if n == 1
        panels = {I, result1a, result1b, result};
        layout = [2 2];
        caption = 'Original / Method 1 (top), Method 2 / Method 3 (bottom)';
    else
        panels = {I, result};
        layout = [1 2];
        caption = 'Original (left) / Method 3 (right)';
    end
    figure('Color', 'w', 'Name', subjects{n});
    montage(panels, 'Size', layout, 'BorderSize', 4, 'BackgroundColor', 'white');
    title(sprintf('%02d  %s  |  Disk radius %d px\n%s', ...
        n, subjects{n}, radius(n), caption));

    if write_results
        imwrite(result, fullfile(output_dir, sprintf('image%d_bokeh.png', n)));
        comparison = imtile(panels, 'GridSize', layout, 'BorderSize', 4, ...
            'BackgroundColor', 'white');
        imwrite(comparison, fullfile(output_dir, sprintf('image%d_comparison.png', n)));
    end
end
result1 = results{1};

function I = readInput(name, local_images, repository_images)
    local_file = fullfile(local_images, name);
    if isfile(local_file)
        I = imread(local_file);
    elseif strcmp(name, 'couple.png') && exist('couple.jpg', 'file') == 2
        I = imread('couple.jpg');
    elseif exist(name, 'file') == 2
        I = imread(name);
    elseif ~isempty(repository_images)
        I = imread([repository_images name]);
    else
        error('Image %s is missing. Keep images/ by the script or set repository_images.', name);
    end
end

function result = method1(I, mask, filter)
    I_blur = imfilter(I, filter, 'replicate');
    result = I_blur .* (1 - mask) + I .* mask;
end

function result = method2(I, mask, filter)
    bg = I .* (1 - mask);
    bg_blur = imfilter(bg, filter, 'replicate');
    result = bg_blur .* (1 - mask) + I .* mask;
end

function result = method3(I, mask, filter)
    bg = 1 - mask;
    weighted_sum = imfilter(I .* bg, filter, 'replicate');
    weight = imfilter(bg, filter, 'replicate');
    blurred_bg = weighted_sum ./ weight;
    blurred_bg(isnan(blurred_bg)) = 0;
    result = blurred_bg .* bg + I .* mask;
end
