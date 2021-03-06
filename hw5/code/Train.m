function [W, b] = Train(W, b, train_data, train_labels, learning_rate)
% [W, b] = Train(W, b, train_data, train_labels, learning_rate) trains the network
% for one epoch on the input training data 'train_data' and 'train_labels'. This
% function should returned the updated network parameters 'W' and 'b' after
% performing backprop on every data sample.


% This loop template simply prints the loop status in a non-verbose way.
% Feel free to use it or discard it


for i = 1:size(train_data,1)
    [~, act_h, act_a] = Forward(W, b, train_data(i,:));
    [grad_W, grad_b] = Backward(W, b, train_data(i, :), train_labels(i, :), act_h, act_a);
    [W, b] = UpdateParameters(W, b, grad_W, grad_b, learning_rate);

    if mod(i, 500) == 0
        fprintf('Done %.2f %%\n', i/size(train_data,1)*100)
    end
end


end
