function xy = Capture_Foreground(filename)
% Click around the foreground on the final, resized input.
I = imread(filename);
figure('Name', 'Trace foreground');
imshow(I);
title('Click along the subject edge. Double-click to finish.');
outline = drawpolygon('Color', 'cyan');
xy = round(outline.Position);
if size(xy,1) < 3
    error('Trace a polygon with at least three points.');
end
fprintf('vertices{6} = [\n');
fprintf('    %d %d;\n', xy.');
fprintf('];\n');
end
