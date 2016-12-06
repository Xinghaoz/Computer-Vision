function [lines, bw] = findLetters(im)
% [lines, BW] = findLetters(im) processes the input RGB image and returns a cell
% array 'lines' of located characters in the image, as well as a binary
% representation of the input image. The cell array 'lines' should contain one
% matrix entry for each line of text that appears in the image. Each matrix entry
% should have size Lx4, where L represents the number of letters in that line.
% Each rows of the matrix should contain 4 numbers [x1, y1, x2, y2] representing
% the top-left and bottom-right position of each box. The rects in one line should
% be sorted by x1 value.
    figure();
    imshow(im);
    hold on;

    [~, ~, layers] = size(im);
    if layers == 3
        im = rgb2gray(im);
    end

    bw = im2bw(im, graythresh(im));
    bw = ~bw;

    CC = bwconncomp(bw);
    pixels = CC.PixelIdxList;
    L = labelmatrix(CC);

    threshold = 10;
    margin = size(im, 2) / 200;
    rects = [];

    for n = 1 : length(pixels)
        [rows, cols] = find(L == n);
        up = min(rows);
        down = max(rows);
        left = min(cols);
        right = max(cols);

        if down - up < threshold + size(im, 2) / 90 || right - left < threshold
            continue;
        end

        rects = [rects [left - margin; up - margin; right + margin; down + margin]];
    end

    [~, I] = sort(rects(2,:));
    rects = rects(:,I);

    line_matrix = rects(:,1);
    line_num = 1;

    lines = cell(1, 1);
    for i = 2 : size(rects, 2)
        if rects(2, i) > rects(4, i - 1)
            lines{line_num} = line_matrix';
            line_num = line_num + 1;
            line_matrix = rects(:, i);
        else
            line_matrix = [line_matrix rects(:, i)];
        end
    end
    lines{line_num} = line_matrix';

    for i = 1 : length(lines)
        line = lines{i}';
        [~, I] = sort(line(1,:));
        line = line(:,I);
        lines{i} = line';
        for j = 1 : size(line, 2)
            rectangle('Position', [line(1,j) line(2,j)...
                line(3,j) - line(1,j) line(4,j) - line(2,j)],...
                'EdgeColor', 'r', 'LineWidth', 1);
        end
    end

end
