function myrun = mysingle(index, mode)
% A script that integrate all the parts of this project.

    load('traintest.mat');
    load('myParameters.mat');


    source = ['../dat/' ,train_imagenames{index}];
    img = imread(source);

    train_imagenames = train_imagenames(index);

    filterBank  = createFilterBank();

    %[~, dictionary] = getFilterBankAndDictionary(strcat(['../dat/'],train_imagenames), filterBank);
    if mode == 1
        computeDictionary();
    end

    load('dictionary.mat');

    wordMap = getVisualWords(img, filterBank, dictionary);

    h = getImageFeaturesSPM(3, wordMap, K);

    figure(1);
    %subplot(2,1,1);
    imshow(img);
    %subplot(2,1,2);
    figure(3);
    imagesc(wordMap);

end
