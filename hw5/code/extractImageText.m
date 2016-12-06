function [text] = extractImageText(fname)
% [text] = extractImageText(fname) loads the image specified by the path 'fname'
% and returns the next contained in the image as a string.
    fname = strcat('../images/', fname)
    load('nist36_after.mat', 'W', 'b');
    im = imread(fname);
    % Use Gaussian filter to reduce the noice.
    im = imgaussfilt(im, 1.5);

    [lines, bw] = findLetters(im);
    line_size = length(lines);
    result = cell(1, line_size);
    text_result = cell(1,line_size);
    outputs = cell(1, line_size);
    text_labels = cell(1, line_size);
    l = 32;
    text = '';

    for i = 1 : line_size
        line = lines{i};
        result{i} = zeros(size(line,1), l * l);
        for j = 1 : size(line,1)
            temp = bw(line(j, 2) : line(j, 4), line(j, 1) : line(j, 3));
            temp = imresize(temp, [l l]);
            result{i}(j, :) = reshape(~temp, 1, l * l);
        end
    end

    for i = 1 : line_size
        [outputs{i}] = Classify(W, b, result{i});
        outputs_t = outputs{i}';
        [~, text_labels{i}] = max(outputs_t);
    end

    class = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L'...
                'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X'...
                'Y' 'Z' '0' '1' '2' '3' '4' '5' '6' '7' '8' '9' '0'];

    for i = 1 : line_size
        [text_result{i}] = class(text_labels{i});
    end

    for i = 1 : (line_size - 1)
        text = [text text_result{i} char(10)];
    end
    text = [text text_result{line_size}];
    fprintf('Extracted text from %s:\n%s\n', fname, text);

end
