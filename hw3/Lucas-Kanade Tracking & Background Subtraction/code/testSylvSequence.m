function testSylvSequence()

    load('../data/sylvseq.mat');
    load('../data/sylvbases.mat');

    rect = [102, 62, 156, 108];

    n = size(frames, 3);
    firstFrame = squeeze(frames(:, :, 1));
    rects = zeros(n, 4);
    rect_lk = rect;
    rect_lkwab = rect;

    previous = frames(:, :, 1);

    for i = 2 : n
        current = frames(:, :, i);

        previous = frames(:, :, i - 1);

        [u, v] = LucasKanadeInverseCompositional(previous, current, rect_lk);
        rect_lk = rect_lk + [u, v, u, v];

        [u, v] = LucasKanadeBasis(previous, current, rect_lkwab, bases);
        rect_lkwab = rect_lkwab + [u, v, u, v];

        imshow(current);
        hold on

        rectangle('Position', [rect_lk(1), rect_lk(2), rect_lk(3) - rect_lk(1), rect_lk(4) - rect_lk(2)], 'EdgeColor', 'g');

        rectangle('Position', [rect_lkwab(1), rect_lkwab(2), rect_lkwab(3) - rect_lkwab(1), rect_lkwab(4) - rect_lkwab(2)], 'EdgeColor', 'y');
        hold off

        title(sprintf('Frame [%d/%d]', i, n));

        rects(i, :) = rect_lkwab;

        previous = current;
        pause(0.1);

    end

    save('sylvseqrects.mat', 'rects');
