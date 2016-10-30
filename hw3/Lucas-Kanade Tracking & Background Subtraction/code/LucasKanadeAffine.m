function M = LucasKanadeAffine(It, It1)

% input - image at time t, image at t+1
% output - M affine transformation matrix

    It = im2double(It);
    It1 = im2double(It1);

    threshold = 0.1;
    p = zeros(6, 1);
    dp = 2 * ones(6, 1);

    [X, Y] = meshgrid(1 : size(It, 2), 1 : size(It, 1));
    ImagePoints = [X(:)'; Y(:)'; ones(size(X(:)'))];

    [It1x, It1y] = gradient(It1);

    while norm(dp) >= threshold

        M = [1 + p(1), p(3), p(5); p(2), 1 + p(4), p(6); 0, 0, 1];

        WX = M * ImagePoints;

        I = interp2(X, Y, It1, WX(1, :)', WX(2, :)');
        I = reshape(I, size(It1));

        common = ~isnan(I);

        I(isnan(I)) = 0;

        D = It - I;

        Ix = interp2(X, Y, It1x, WX(1, :)', WX(2, :)');
        Ix(~common) = 0;
        Iy = interp2(X, Y, It1y, WX(1, :)', WX(2, :)');
        Iy(~common) = 0;

        SD = [Ix(:) .* X(:), Iy(:) .* X(:), Ix(:) .* Y(:), Iy(:) .* Y(:), Ix(:), Iy(:)];

        H = SD' * SD;

        b = SD' * D(:);

        dp = H \ b;
        p = p + dp;
    end
