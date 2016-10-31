function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs:
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W*H x N*3 matrix of filter responses


	% TODO Implement your code here

	% If it is a gray-scale image, duplicated it into three channels.

	filterBank = createFilterBank();
	[F, ~] = size(filterBank);
	[W,H,c] = size(img);
	if c == 1
		temp = img;
		img(:,:,1) = temp;
		img(:,:,2) = temp;
		img(:,:,3) = temp;
	end

	labImg = RGB2Lab(img);

	filterResponses = zeros(W * H, F * 3);

	for bank_index = 1 : F
		for channel_index = 1 : 3
			temp = imfilter(labImg(:,:,channel_index), filterBank{bank_index});
			res = reshape(temp, [W * H, 1]);
			filterResponses(:,(bank_index - 1) * 3 + channel_index) = res;
		end
	end

	%filterResponses = zeros(F * 3, W * H);

	%for bank_index = 1 : F
		%for layer_index = 1 : 3
			%temp = imfilter(labImg(:,:,layer_index), filterBank{bank_index});
			%filterResponses((bank_index - 1) * 3 + layer_index,:) = reshape(temp, [1, W * H]);
		%end
	%end

	%filterResponses = transpose(filterResponses);

end
