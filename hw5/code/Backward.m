function [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a)
% [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a) computes the gradient
% updates to the deep network parameters and returns them in cell arrays
% 'grad_W' and 'grad_b'. This function takes as input:
%   - 'W' and 'b' the network parameters
%   - 'X' and 'Y' the single input data sample and ground truth output vector,
%     of sizes Nx1 and Cx1 respectively
%   - 'act_a' and 'act_h' the network layer pre and post activations when forward
%     forward propogating the input smaple 'X'
    len = length(W);
    grad_W = cell(1, len);
    grad_b = cell(1, len);

    output = softmax(act_a{len}')';

    loss = (output - Y);

    grad_b{len} = loss;
    grad_W{len} = act_h{len - 1}' * loss;

    last_one = loss * W{len}';
    for i = len - 1: -1: 2
        grad_b{i} = act_h{i} .* (1 - act_h{i}) .* last_one;
        grad_W{i} = act_h{i - 1}' * grad_b{i};
        last_one = last_one * W{i}';
    end
    grad_b{1} = act_h{1} .* (1 - act_h{1}) .* last_one;
    grad_W{1} = X' * grad_b{1};
end
