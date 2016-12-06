load('../data/nist36_train.mat', 'train_data', 'train_labels')
load('../data/nist36_test.mat', 'test_data', 'test_labels')
load('../data/nist36_valid.mat', 'valid_data', 'valid_labels')
load('../data/nist26_model_60iters.mat', 'W', 'b');

num_epoch = 5;
classes = 36;
layers = [32*32, size(W{1}, 1), classes];
learning_rate = 0.01;

len = length(W);
for i = 1 : len - 1
    W{i} = W{i}';
    b{i} = b{i}';
end

temp = W{1};
save('nist36_before', 'W', 'b');

a = sqrt(6) / sqrt(layers(2) + classes);
W{len} = -a + (2 * a) * rand(layers(2), classes);
b{len} = zeros(1, classes);

perm = randperm(size(train_data, 1));
train_data = train_data(perm, :);
train_labels = train_labels(perm, :);

perm_2 = randperm(size(valid_data, 1));
valid_data = valid_data(perm_2, :);
valid_labels = valid_labels(perm_2, :);

train_accs = zeros(1, num_epoch);
train_losses = zeros(1, num_epoch);
valid_accs = zeros(1, num_epoch);
valid_losses = zeros(1, num_epoch);

for j = 1:num_epoch
    fprintf('Processing Epoch %d\n', j);
    [W, b] = Train(W, b, train_data, train_labels, learning_rate);

    [train_acc, train_loss] = ComputeAccuracyAndLoss(W, b, train_data, train_labels);
    [valid_acc, valid_loss] = ComputeAccuracyAndLoss(W, b, valid_data, valid_labels);

    train_accs(j) = train_acc;
    train_losses(j) = train_loss;
    valid_accs(j) = valid_acc;
    valid_losses(j) = valid_loss;

    % fprintf('Epoch %d - accuracy: %.5f, %.5f \t loss: %.5f, %.5f \n', j, train_acc, valid_acc, train_loss, valid_loss)
end

temp = W{1};
save('nist36_after', 'W', 'b', 'train_accs', 'train_losses', 'valid_accs', 'valid_losses');

x = 1 : num_epoch;
figure(1);
plot(x, train_accs, x, valid_accs);
title('Accuracy with learning rate = 0.01')
xlabel('Number of Epoch')
ylabel('Accuracy')
legend('Training set', 'Validation set');
figure(2);
plot(x, train_losses, x, valid_losses);
title('Loss with learning rate = 0.01')
xlabel('Number of Epoch')
ylabel('Loss')
legend('Training set', 'Validation set');

% Show the result on the test set
[test_acc, test_loss] = ComputeAccuracyAndLoss(W, b, test_data, test_labels)
