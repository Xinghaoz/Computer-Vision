function testCarSequence()
    load('../data/carseq.mat');

    [x, y, n] = size(frames);

    rect = [60, 117, 146, 152];

    rects = zeros(n, 4);
    previous = frames(:, :, 1);

    for i = 2 : n
        current = frames(:, :, i);

        [u, v] = LucasKanadeInverseCompositional(previous, current, rect);
        rect = rect + [u, v, u, v];

        imshow(current);
        hold on

        rectangle('Position', [rect(1), rect(2), rect(3) - rect(1), rect(4) - rect(2)], 'EdgeColor', 'y');
        hold off

        title(sprintf('Frame [%d/%d]', i, n));

        rects(i, :) = rect;
        previous = current;

        pause(0.1);

    end

    save('carseqrects.mat', 'rects');
