function checkGradient(rounds)
    if nargin < 1
        rounds = 100;
    end

    layers = [1024 400 26];
    inputs = rand(1, 1024);
    outputs = [1 zeros(1, 25)];
    D = size(inputs, 2);

    [W, b] = InitializeNetwork(layers);
    [output, act_h, act_a] = Forward(W, b, inputs);
    [grad_W, grad_b] = Backward(W, b, inputs, outputs, act_h, act_a);

    len = length(W);
    sum = zeros(len, 1);

    for k = 1 : rounds
        idx = len - 1;
        w = W{len};
        w_0 = w;
        w_1 = w;

        [row_size, col_size] = size(w);
        row = randsample(row_size, 1);
        col = randsample(col_size, 1);

        w_0(row, col) = w_0(row, col) - 0.001;
        w_1(row, col) = w_1(row, col) + 0.001;

        output_0 = (act_h{len - 1}) * w_0 + repmat(b{len}, D, 1);
        T_0 = softmax(output_0')';
        l_0 = - sum(log(T_0 * outputs'));

        output_1 = (act_h{len - 1}) * w_1 + repmat(b{len}, D, 1);
        T1 = softmax(output_1')';
        l1 = - sum(log(T1 * outputs'));

        grad = (l1 - l_0) ./ 0.002;
        gradw = grad_W{end};
        error = abs(grad - gradw(row, col));
        sum(end) = sum(end) + error;

        for i = 1 : len - 2
            w = W{idx};
            w_0 = w;
            w_1 = w;

            [row_size, col_size] = size(w);
            row = randsample(row_size, 1);
            col = randsample(col_size, 1);
            w_0(row, col) = w_0(row, col) - 0.001;
            w_1(row, col) = w_1(row, col) + 0.001;
            index_0 = act_h{idx - 1};
            index_1 = index_0;

            for j = idx : len - 1
                output_0 = index_0 * w_0;
                index_0 = sigmf(output_0, [1 0]);
                w_0 = W{j + 1};

                output_1 = index_1 * w_1;
                index_1 = sigmf(output_1, [1 0]);
                w_1 = W{j + 1};
            end

            index_0 = index_0 * w_0;
            T_0 = softmax(index_0')';
            l_0 = - sum(log(T_0 * outputs'));

            index_1 = index_1 * w_1;
            T1 = softmax(index_1')';
            l1 = - sum(log(T1 * outputs'));

            grad = (l1 - l_0) ./ 0.002;
            gradw = grad_W{idx};
            error = abs(grad - gradw(row, col));
            sum(idx) = sum(idx) + error;
            idx = idx - 1;
        end

        w = W{1};
        w_0 = w;
        w_1 = w;

        [row_size, col_size] = size(w);
        row = randsample(row_size, 1);
        col = randsample(col_size, 1);

        w_0(row, col) = w_0(row, col) - 0.001;
        w_1(row, col) = w_1(row, col) + 0.001;
        index_0 = inputs;
        index_1 = index_0;

        for j = 1 : len - 1
            output_0 = index_0 * w_0;
            index_0 = sigmf(output_0, [1 0]);
            w_0 = W{j + 1};

            output_1 = index_1 * w_1;
            index_1 = sigmf(output_1, [1 0]);
            w_1 = W{j + 1};
        end

        index_0 = index_0 * w_0;
        T_0 = softmax(index_0')';
        l_0 = - sum(log(T_0 * outputs'));

        index_1 = index_1 * w_1;
        T1 = softmax(index_1')';
        l1 = - sum(log(T1 * outputs'));

        grad = (l1 - l_0) ./ 0.002;
        gradw = grad_W{1};
        error = abs(grad - gradw(row, col));
        sum(1) = sum(1) + error;
    end

    average = sum / rounds
