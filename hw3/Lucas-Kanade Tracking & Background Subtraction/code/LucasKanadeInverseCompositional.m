function [u,v] = LucasKanadeInverseCompositional(It, It1, rect, p)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [u,v] in the x- and y-directions.

    if nargin < 4
        p = [0;0];
    end

    u = p(1);
    v = p(2);

    It = im2double(It);
    It1 = im2double(It1);

    threshold = 0.1;
    dp = 2 * [threshold;threshold];

    [X, Y] = meshgrid(rect(1) : rect(3), rect(2) : rect(4));
    T = interp2(It, X, Y);

    % T = It(rect(2) : rect(4), rect(1) : rect(3));
    % T = It(floor(rect(2)) : floor(rect(4)), floor(rect(1)) : floor(rect(3)));
    % T = It(round(rect(2)) : round(rect(4)), round(rect(1)) : round(rect(3)));

    [Tx, Ty] = gradient(T);

    Jacobian = [Tx(:) Ty(:)]' * [Tx(:) Ty(:)];

    while norm(dp) >= threshold

        [X, Y] = meshgrid((rect(1) : rect(3)) + u, (rect(2) : rect(4)) + v);
        I = interp2(It1, X, Y);
        % I = It1(rect(2) + p(2) : rect(4) + p(2), rect(1) + p(1) : rect(3) + p(1));

        D = I - T;

        b = [Tx(:) Ty(:)]' * D(:);

        dp = Jacobian \ b;

        u = u - dp(1);
        v = v - dp(2);
    end
