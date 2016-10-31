function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    % TODO Implement your code here
    histSize = dictionarySize * (4 ^ layerNum - 1) / 3;
    h = zeros(histSize, 1);

    [H, W] = size(wordMap);

    for row = 1 : H
        for col = 1 : W
            secondIndex = floor((row - 1) / (H / 2)) * 2 + floor((col - 1) / (W / 2)); % Start from 0
            thirdIndex = floor((row - 1) / (H / 4)) * 4 + floor((col - 1) / (W / 4)); % Start from 0

            wordIndex = wordMap(row, col);
            secondWordIndex = dictionarySize + secondIndex * dictionarySize + wordIndex;
            thirdWordIndex = 5 * dictionarySize + thirdIndex * dictionarySize + wordIndex;

            h(wordIndex) = h(wordIndex) + 1;
            h(secondWordIndex)  = h(secondWordIndex) + 1;
            h(thirdWordIndex) = h(thirdWordIndex) + 1;

        end
    end


    h(1 : dictionarySize) = h(1 : dictionarySize) / 65536 * 0.25;

    for i = 1 : 4
        h(1 + dictionarySize * i : dictionarySize * (i + 1)) = h(1 + dictionarySize * i : dictionarySize * (i + 1)) / 16384 * 0.25;
    end

    for i = 5 : 20
        h(1 + dictionarySize * i : dictionarySize * (i + 1)) = h(1 + dictionarySize * i : dictionarySize * (i + 1)) / 4096 * 0.5;
    end

    h = h / sum(h);

end
