function [u,v] = LucasKanadeBasis(It, It1, rect, bases)

% input - image at time t, image at t+1, rectangle (top left, bot right
% coordinates), bases
% output - movement vector, [u,v] in the x- and y-directions.

    It = im2double(It);
    It1 = im2double(It1);

    tol = 0.1;
    lambda = zeros(size(bases, 3), 1);
    started = 0;
    p = [0;0];
    errcomp = 0.1;

    [X, Y] = meshgrid(rect(1) : rect(3) + errcomp, rect(2) : rect(4) + errcomp);
    T = interp2(It, X, Y);

    while norm(lambda) >= tol || started == 0
        started = 1;

        deltap = 2 * [tol tol]';

        for i = 1 : size(bases, 3)
            T = T + lambda(i) * bases(:, :, i);
        end

        [Tx, Ty] = gradient(T);

        SDQ = [Tx(:) Ty(:)]';
        for m = 1 : size(bases, 3)
            basism = bases(:, :, m);
            SDQ = SDQ - (basism(:)' * [Tx(:) Ty(:)])' * basism(:)';
        end

        H = SDQ * SDQ';

        ps = [];
        while norm(deltap) >= tol

            [X, Y] = meshgrid((rect(1) : rect(3) + errcomp) + p(1), (rect(2) : rect(4) + errcomp) + p(2));
            I = interp2(It1, X, Y);

            D = I - T;

            b = SDQ * D(:);

            deltap = H \ b;

            p = p - deltap;
            ps = [ps, deltap];
        end

        u = p(1);
        v = p(2);

        [X, Y] = meshgrid((rect(1) : rect(3) + errcomp) + u, (rect(2) : rect(4) + errcomp) + v);
        I = interp2(It1, X, Y);
        D = I - T;

        lambda = zeros(size(bases, 3), 1);
        for i = 1 : size(bases, 3)
            basisi = bases(:, :, i);
            lambda(i) = basisi(:)' * D(:);
        end

    end
