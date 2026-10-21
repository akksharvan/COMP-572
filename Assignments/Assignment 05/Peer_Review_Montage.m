% Export the original images and existing pyramid blend for Canvas peer review.
root_folder = fileparts(mfilename('fullpath'));
source = imread(fullfile(root_folder, 'images', 'set5_source.png'));
background = imread(fullfile(root_folder, 'images', 'set5_background.png'));
blend = imread(fullfile(root_folder, 'results', 'set5_pyramid_blending.png'));

fig = figure('Visible', 'off', 'Color', 'white', ...
    'Position', [100 100 2100 820]);
ax = axes(fig, 'Position', [0.02 0.08 0.96 0.84]);
montage({source, background, blend}, 'Size', [1 3], ...
    'ThumbnailSize', [720 720], 'BorderSize', [12 12], ...
    'BackgroundColor', 'white', 'Parent', ax);
labels = {'Original source', 'Original background', 'Pyramid blend'};
for k = 1:3
    annotation(fig, 'textbox', [0.02 + (k-1)*0.32 0.92 0.32 0.06], ...
        'String', labels{k}, 'EdgeColor', 'none', ...
        'HorizontalAlignment', 'center', 'FontSize', 18);
end
exportgraphics(fig, fullfile(root_folder, 'results', ...
    'Assignment5_Peer_Review_Mickey_on_Couch.png'), 'Resolution', 150);
close(fig);
