function myrun(K, alpha)
% A script that integrate all parts of this project.

    createMyParameters(K, alpha);

    computeDictionary();

    batchToVisualWords(2);

    buildRecognitionSystem();

    evaluateRecognitionSystem();
end
