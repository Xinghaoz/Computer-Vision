function [h] = getImageFeatures(wordMap, dictionarySize)
% Compute histogram of visual words
% Inputs:
% 	wordMap: WordMap matrix of size (h, w)
% 	dictionarySize: the number of visual words, dictionary size
% Output:
%   h: vector of histogram of visual words of size dictionarySize (l1-normalized, ie. sum(h(:)) == 1)

	% TODO Implement your code here

	[H, W] = size(wordMap);

	h = zeros(dictionarySize, 1);
	mapSum = H * W;
	for index = 1 : H * W
		h(wordMap(index)) = h(wordMap(index)) + 1;
	end

	h = h / sum(h);

	assert(numel(h) == dictionarySize);
end
