function [u, v] = testCarSequenceWithTemplateCorrection()

    threshold = 2;

    load('../data/carseq.mat');

    [x, y, n] = size(frames);
    firstFrame = frames(:, :, 1);

    rect0 = [60, 117, 146, 152];
    % rect0 = [102, 62, 156, 108];

    rects = zeros(n, 4);
    rect_without = rect0;
    rect_lkwtc = rect0;

    previous = frames(:, :, 1);
    for i = 2 : n
        current = frames(:, :, i);

        previous = frames(:, :, i - 1);

        [u_origin, v_origin] = LucasKanadeInverseCompositional(previous, current, rect_without);
        rect_without = rect_without + [u_origin, v_origin, u_origin, v_origin];

        [u_origin, v_origin] = LucasKanadeInverseCompositional(previous, current, rect_lkwtc);
        rect_compare = rect_lkwtc + [u_origin, v_origin, u_origin, v_origin];

        [u_star, v_star] = LucasKanadeInverseCompositional(firstFrame, current, rect0, ...
            (rect_compare(1 : 2) - rect0(1 : 2))' );

        u_star = u_star - (rect_lkwtc(1) - rect0(1));
        v_star = v_star - (rect_lkwtc(2) - rect0(2));

        if norm([u_star, v_star] - [u_origin, v_origin]) <= threshold
            u = u_star;
            v = v_star;
        else
            u = u_origin;
            v = v_origin;
        end

        rect_lkwtc = rect_lkwtc + [u, v, u, v];

        imshow(current);
        hold on

        rectangle('Position', [rect_without(1), rect_without(2), rect_without(3) - rect_without(1), rect_without(4) - rect_without(2)], 'EdgeColor', 'g');

        rectangle('Position', [rect_lkwtc(1), rect_lkwtc(2), rect_lkwtc(3) - rect_lkwtc(1), rect_lkwtc(4) - rect_lkwtc(2)], 'EdgeColor', 'y');
        hold off

        title(sprintf('Frame [%d/%d]', i, n));

        rects(i, :) = rect_lkwtc;

        previous = current;

        pause(0.1);

    end

    save('carseqrects-wcrt.mat', 'rects');
