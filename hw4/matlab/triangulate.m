function [ P, error ] = triangulate( M1, p1, M2, p2 )
% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       M2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

% Q2.4 - Todo:
%       Implement a triangulation algorithm to compute the 3d locations
%       See Szeliski Chapter 7 for ideas
%
    N = size(p1, 1);
    P = zeros(N, 3);

    for i = 1 : N
        A = zeros(4,4);

        A(1,:) = p1(i,1) * M1(3,:) - M1(1,:);
        A(2,:) = p1(i,2) * M1(3,:) - M1(2,:);
        A(3,:) = p2(i,1) * M2(3,:) - M2(1,:);
        A(4,:) = p2(i,2) * M2(3,:) - M2(2,:);

        [~,~,V] = svd(A);

        P(i, :) = V(1 : 3, end)' / V(4, end);
    end

    P_hmg = [P, ones(N, 1)]';

    p1_hat = (M1 * P_hmg)';
    p1_hat = p1_hat(:, 1 : 2) ./ repmat(p1_hat(:, 3), 1, 2);

    p2_hat = (M2 * P_hmg)';
    p2_hat = p2_hat(:, 1 : 2) ./ repmat(p2_hat(:, 3), 1, 2);

    error = sum((p1(:) - p1_hat(:)).^2 + (p2(:) - p2_hat(:)).^2);
end
