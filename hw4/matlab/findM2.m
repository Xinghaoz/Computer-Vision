% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, p1, p2, R and P to q2_5.mat

    load('../data/some_corresp.mat');
    load('../data/intrinsics.mat');
    img1 = imread('../data/im1.png');
    img2 = imread('../data/im2.png');

    M = max(max(size(img1)),max(size(img2)));

    F = eightpoint(pts1, pts2, M);
    E = essentialMatrix(F, K1, K2);

    M1 = [eye(3),zeros(3,1)];
    M2s = camera2(E);

    min_error = inf;

    for i = 1 : 1 : size(M2s,3)
        M2_i = M2s(:,:,i);
        [ P_i, errors ] = triangulate( K1*M1, pts1, K2*M2_i, pts2 );
        if errors < min_error
            M2 = M2_i;
            min_error = errors;
            P = P_i;
        end

    end

    p1 = pts1;
    p2 = pts2;
    save('q2_5.mat', 'M2', 'p1', 'p2', 'P');
