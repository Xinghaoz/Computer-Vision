function [W, b] = InitializeNetwork(layers)
% InitializeNetwork([INPUT, HIDDEN1, HIDDEN2, ..., OUTPUT]) initializes the weights and biases
% for a fully connected neural network with input data size INPUT, output data
% size OUTPUT, and in between are the number of hidden units in each of the layers.
% It should return the cell arrays 'W' and 'b' which contain the randomly
% initialized weights and biases for this neural network.

    W = cell(1, length(layers) - 1);
    b = cell(1, length(layers) - 1);

    previous = layers(1);
    for i = 1 : length(layers) - 1
        % Choice 1: Initialize to random value
        % b{i} = zeros(1, layers(i + 1));
        % W{i} = rand(previous, layers(i + 1));
        % previous = layers(i + 1);

        % Choice 2: According to "http://neuralnetworksanddeeplearning.com/chap3.html#weight_initialization"
        a = sqrt(6) / sqrt(previous + layers(i + 1));
        b{i} = zeros(1, layers(i + 1));
        W{i} = -a + (2 * a) * rand(previous, layers(i + 1));
        previous = layers(i + 1);
    end


end
