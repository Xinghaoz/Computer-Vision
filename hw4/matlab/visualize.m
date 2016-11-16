% Q2.7 - Todo:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3

    load('../data/templeCoords.mat');
    load('../data/intrinsics.mat');
    load('../data/some_corresp.mat');
    img1 = imread('../data/im1.png');
    img2 = imread('../data/im2.png');

    M = max(max(size(img1)),max(size(img2)));

    F = eightpoint(pts1, pts2, M);
    E = essentialMatrix(F, K1, K2);

    x2 = zeros(size(x1));
    y2 = zeros(size(y1));

    for i = 1 : length(x1)
        [x2(i), y2(i)] = epipolarCorrespondence(img1, img2, F, x1(i), y1(i));
    end

    pts1 = [x1 y1];
    pts2 = [x2 y2];

    M1 = [eye(3), zeros(3, 1)];

    M2s = camera2(E);

    M1 = K1 * M1;
    for i = 1 : size(M2s, 3)
        M2s(:, :, i) = K2 * squeeze(M2s(:,:,i));
    end

    P = [];
    M2 = [];
    for i = 1 : size(M2s, 3)

        M2_i = squeeze(M2s(:, :, i));

        [P_i, ~] = triangulate(M1, pts1, M2_i, pts2);

        if all(P_i(:, 3) > 0)
            P = P_i;
            M2 = M2_i;
        end

    end

    scatter3(P(:, 1), P(:, 2), P(:, 3));
    rotate3d on;

    save('q2_7.mat','F','M1','M2');
