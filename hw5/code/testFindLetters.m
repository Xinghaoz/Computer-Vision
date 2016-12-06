images = cell(1, 4);
images{1} = imread('../images/01_list.jpg');
images{2} = imread('../images/02_letters.jpg');
images{3} = imread('../images/03_haiku.jpg');
images{4} = imread('../images/04_deep.jpg');

for i = 1 : 4
    findLetters(images{i});
end
