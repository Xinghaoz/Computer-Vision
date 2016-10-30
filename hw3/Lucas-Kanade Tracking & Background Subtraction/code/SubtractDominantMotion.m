function mask = SubtractDominantMotion(image1, image2)

% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size

    image1 = im2double(image1);
    image2 = im2double(image2);

    M = LucasKanadeAffine(image1, image2);

    out_size = [size(image2, 1), size(image2, 2)];

    tform = maketform( 'projective', M');
    image_warped = imtransform(image1, tform, 'bilinear', 'XData', ...
	[1 out_size(2)], 'YData', [1 out_size(1)], 'Size', out_size(1:2), 'FillValues', NaN * ones(size(image1, 3), 1));

    common = ~isnan(image_warped);
    image_warped(~common) = 0;

    mask = abs(image2 - image_warped) .* common;

    thresh = graythresh(mask);
    mask = im2bw(mask, thresh);

    mask = medfilt2(mask);

    SE = strel('disk', 8);

    mask = imdilate(mask, SE);
    mask = imerode(mask, SE);

    mask = mask - bwareaopen(mask, 500);
