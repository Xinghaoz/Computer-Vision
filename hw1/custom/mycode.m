function guessedImage = mycode()
    %load('vision.mat');
    load('traintest.mat');
    load('dictionary.mat');

    source = '../dat/';
    % 77, 25, 7, 1111
    index = [100,200,300,400];
    for i = 1 : 4
        %img = imread([source,train_imagenames{250}]);
        img = imread([source,train_imagenames{index(i)}]);
        subplot(2,4,i);
        imshow(img);
        subplot(2,4,i + 4);
        wordMap = getVisualWords(img, filterBank, dictionary);
        % wordMap = transpose(wordMap);
        imagesc(wordMap);
    end

end
