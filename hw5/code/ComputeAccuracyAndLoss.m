function [accuracy, loss] = ComputeAccuracyAndLoss(W, b, data, labels)
% [accuracy, loss] = ComputeAccuracyAndLoss(W, b, X, Y) computes the networks
% classification accuracy and cross entropy loss with respect to the data samples
% and ground truth labels provided in 'data' and labels'. The function should return
% the overall accuracy and the average cross-entropy loss.
    outputs = Classify(W, b, data);
    [~, idx] = max(outputs, [], 2);
    y = zeros(size(outputs));

    for i = 1 : size(labels, 1)
        y(i, idx(i)) = 1;
    end

    accuracy = y .* labels;
    accuracy = sum(accuracy(:)) / size(labels, 1);
    loss = diag(outputs' * labels);
    loss = log(loss);
    loss = - sum(loss) / size(labels, 1);
end
