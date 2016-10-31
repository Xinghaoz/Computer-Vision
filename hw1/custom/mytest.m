function mycode(index)
    %load('vision.mat');
    load('traintest.mat');
    load('dictionary.mat');

    source = '../dat/';
    img = imread([source,train_imagenames{index}]);
    figure(1);
    %subplot(2,1,1);
    imshow(img);
    %subplot(2,1,2);
    figure(2);
    wordMap = getVisualWords(img, filterBank, dictionary);
    %wordMap = transpose(wordMap);
    imagesc(wordMap);

end
