function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

	load('dictionary.mat'); % filterBank, dictionary
	load('../dat/traintest.mat'); % all_imagenames, all_labels, train_imagenames, train_labels, test_imagenames, test_labels

	% TODO create train_features
	% function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
	K = 250;
    alpha = 125;
	load('myParameters');
	source = '../dat/';
	[imgNumber, ~] = size(train_imagenames);
	train_features = zeros(21 * K, imgNumber);

	for i = 1 : imgNumber
		imgName = [source, train_imagenames{i}];
		fprintf('Processing img[%d]: %s.\n', i, imgName);
		load(strrep(imgName, '.jpg', '.mat'));
		h = getImageFeaturesSPM(3, wordMap, K);
		train_features(:,i) = h;
	end

	save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');

end
