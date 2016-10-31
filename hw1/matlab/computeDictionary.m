% Computes filter bank and dictionary, and saves it in dictionary.mat

function computeDictionary()

	load('../dat/traintest.mat');

	filterBank  = createFilterBank();

	interval= 1;
	train_imagenames = train_imagenames(1:interval:end);
	[filterBank,dictionary] = getFilterBankAndDictionary(strcat(['../dat/'],train_imagenames), filterBank);

	save('dictionary.mat','filterBank','dictionary');

end
