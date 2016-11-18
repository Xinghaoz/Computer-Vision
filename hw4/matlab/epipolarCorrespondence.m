function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different pointsdow sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup
    points = 9;
    x2 = zeros(size(x1));
    y2 = zeros(size(y1));

    for i = 1 : size(x1, 1)
        x1_i = x1(i);
        y1_i = y1(i);
        if x1_i > size(im2, 2) - (points - 1) / 2 || x1_i < 1 + (points - 1) / 2
            continue;
        end

        if y1_i > size(im1, 2) - (points - 1) / 2 || y1_i < 1 + (points - 1) / 2
            continue;
        end
        trim_img1 = double(im1(y1_i - (points - 1) / 2 : y1_i + (points - 1) / 2, x1_i - (points - 1) / 2 : x1_i + (points - 1) / 2));
        epipolar_line = F * [x1_i; y1_i; 1];

        error = inf;
       for temp_y2 = 1 + (points - 1)/2:1:size(im2, 1) - (points - 1) / 2
           temp_x2 = round((-epipolar_line(2) * temp_y2 - epipolar_line(3)) / epipolar_line(1));

           if temp_x2 > size(im2, 2) - (points - 1) / 2 || temp_x2 < 1 + (points - 1) / 2
               continue;
           end

           trim_img2 = double(im2(temp_y2 - (points - 1) / 2:temp_y2 + (points - 1) / 2,temp_x2 - (points - 1) / 2:temp_x2 + (points - 1) / 2));

           error_i = norm(fspecial('gaussian', [points, points] , 1) .* (trim_img1 - trim_img2));

           if error_i < error
               error = error_i;
               x2(i) = temp_x2;
               y2(i) = temp_y2;
           end
       end
    end

    pts1 = [x1, y1];
    pts2 = [x2, y2];

    save('q2_6.mat','F','pts1','pts2');

end
