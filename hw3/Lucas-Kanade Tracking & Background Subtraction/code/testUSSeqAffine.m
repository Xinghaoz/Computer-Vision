function testUSSeqAffine()

    load('../data/usseq.mat');
    load('usseqrects-wcrt.mat');

    n = size(frames, 3);

    for i = 2 : size(frames, 3)
        current = squeeze(frames(:, :, i));

        mask = SubtractDominantMotion(frames(:, :, i - 1), current);

        mask = uint8(mask);
        resultFrame = uint8(zeros(size(current, 1), size(current, 2), 3));
        resultFrame(:, :, 1) = max(current, 255 * mask);
        resultFrame(:, :, 2) = current .* (1 - mask);
        resultFrame(:, :, 3) = max(current, 255 * mask);

        imshow(resultFrame);

        title(sprintf('Frame [%d/%d]', i, n));

        pause(0.1);
    end
