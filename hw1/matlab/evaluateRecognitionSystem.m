function [conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

	load('vision.mat');
	load('../dat/traintest.mat');

	% TODO Implement your code here
	[testSize, ~] = size(test_imagenames);

	ratio = 0;
	correctCount = 0;
	conf = zeros(8, 8);

	keySet =   {'aquarium', 'beach', 'bridge', 'conference_room', 'gas_station', 'park', 'parking_lot', 'waterfall'};
	valueSet = [1, 2, 3, 4, 5, 6, 7, 8];
	mapObj = containers.Map(keySet,valueSet)


	for i = 1 : testSize
		guessedImage = guessImage(test_imagenames{i});
		fprintf('Evaluating[%d]:%s.\n', i, test_imagenames{i});
		correctAnswer = mapping{test_labels(i)};
		fprintf('%s, %s\n', guessedImage, correctAnswer);
		if strcmp(guessedImage, correctAnswer)
			correctCount = correctCount + 1;
		end
		ratio = correctCount / i;
		conf(mapObj(guessedImage), mapObj(correctAnswer)) = conf(mapObj(guessedImage), mapObj(correctAnswer)) + 1;

	end
	conf
	fprintf('%d correct. Accuracy: %f\n', correctCount, ratio);

	save('conf.mat', 'conf');

end
