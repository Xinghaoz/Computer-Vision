function train26(learning_rate)
    if nargin < 1
        learning_rate = 0.01;
    end
    learning_rate
    num_epoch = 30;
    classes = 26;
    layers = [32*32, 400, classes];

    load('../data/nist26_train.mat', 'train_data', 'train_labels')
    load('../data/nist26_test.mat', 'test_data', 'test_labels')
    load('../data/nist26_valid.mat', 'valid_data', 'valid_labels')

    perm = randperm(size(train_data, 1));
    train_data = train_data(perm, :);
    train_labels = train_labels(perm, :);

    perm_2 = randperm(size(valid_data, 1));
    valid_data = valid_data(perm_2, :);
    valid_labels = valid_labels(perm_2, :);

    [W, b] = InitializeNetwork(layers);

    temp = W{1};
    save('nist26_before_0.01.mat', 'W', 'b');

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
    save('nist26_after_0.001.mat', 'W', 'b', 'train_accs', 'train_losses', 'valid_accs', 'valid_losses');

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
