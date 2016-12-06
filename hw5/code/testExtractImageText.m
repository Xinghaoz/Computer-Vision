function [texts] = testExtractImageText
    images = {'01_list.jpg', '02_letters.jpg', '03_haiku.jpg', '04_deep.jpg'};
    texts = cell(1,4);

    for i = 1 : 4
        texts{i} = extractImageText(images{i});
    end
end
