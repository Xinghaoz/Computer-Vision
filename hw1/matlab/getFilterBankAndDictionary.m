function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths, filterBank)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

    % We don't need to create filterBank everytime.
    % filterBank  = createFilterBank();

    % TODO Implement your code here
    K = 250;
    alpha = 125;
    load('myParameters');
    T = length(imPaths);
    F = length(filterBank);

    filterResponses = zeros(alpha * T, 3 * F);
    for imgIndex = 1 : T
        fprintf('Processing img[%d].\n', imgIndex);

        img = imread(imPaths{imgIndex});

        [~,~,c] = size(img);
    	if c == 1
    		temp = img;
    		img(:,:,1) = temp;
    		img(:,:,2) = temp;
    		img(:,:,3) = temp;
    	end

    	labImg = RGB2Lab(img);

        responses = extractFilterResponses(img, filterBank);
        [responsesSize, ~] = size(responses);

        %perm = randperm(responsesSize);

        perm = randperm(alpha);
        sample = perm(1: alpha);

        sampleResponse = responses(sample);

        for bankIndex = 1 : F
            for j = 1 : 3
                filterResponses((imgIndex - 1) * alpha + 1: imgIndex * alpha, (bankIndex - 1) * 3 + j) = sampleResponse;
            end
        end
    end
    [~, dictionary] = kmeans(filterResponses, K, 'EmptyAction','drop');
    dictionary = transpose(dictionary);
end
