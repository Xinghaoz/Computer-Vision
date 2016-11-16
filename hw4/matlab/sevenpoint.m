function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup
    x1 = pts1(:,1)/M;
    y1 = pts1(:,2)/M;
    x2 = pts2(:,1)/M;
    y2 = pts2(:,2)/M;

    U = [x1 .* x2 , x1 .* y2 , x1 , y1 .* x2 , y1 .* y2 , y1 , x2 , y2 , ones(size(x1))];

    [~, ~, V] = svd(U);
    F1 = reshape(V(:, 8), 3, 3);
    F2 = reshape(V(:, 9), 3, 3);

    syms x
    alpha = roots(sym2poly(det(x * F1 + (1 - x) * F2)));

    T = [1, 0, 0 ; 0, 1, 0; 0, 0, 1] / M;
    T(3,3) = 1;

    size_a = length(alpha);
    F = cell(1, size_a);
    for i = 1 : size_a
        F{i} = alpha(i) * F1 + (1 - alpha(i)) * F2;
        F{i} = T' * F{i} * T;
    end

    save('q2_2.mat','F','M','pts1','pts2');
end
