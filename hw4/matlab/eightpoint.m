function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup
    pts1 = pts1 / M;
    pts2 = pts2 / M;

    x1 = pts1(:, 1);
    y1 = pts1(:, 2);
    x2 = pts2(:, 1);
    y2 = pts2(:, 2);

    U = [x1 .* x2, x1 .* y2, x1, y1 .* x2, y1 .* y2, y1, x2, y2];

    F = U \ -ones(size(pts1, 1), 1);;
    F = reshape([F; 1], [3 3]);

    [U, S, V] = svd(F);
    S(3, 3) = 0;
    F = U * S * V';

    F = refineF(F, pts1, pts2);

    T = diag([1 / M, 1 / M, 1]);

    F = T' * F * T;

    save('q2_1.mat','F','M','pts1','pts2');

end
