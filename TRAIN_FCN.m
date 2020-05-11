%% Script to train a fully-convolutional network

clear all; close all; clc
addpath ('dataset');

% Extract all the positive examples
load ('my_pos_examples.mat');
load ('my_pos_labels.mat');
% Get all the negative examples
load ('my_neg_examples.mat');
load ('my_neg_labels.mat');

% Original architecture of the FCN
layers = [
        imageInputLayer([28 28 3],'Normalization','none');
        convolution2dLayer(5,32); % filter size = 5, 32 filters
        reluLayer();
        maxPooling2dLayer(2,'stride',2); % Pooling size of 2, stride = 2
        convolution2dLayer(5,64); % filter size = 5, 64 filters
        reluLayer();
        maxPooling2dLayer(2,'stride',2); % Pooling size of 2, stride = 2
        convolution2dLayer(3,128); % filter size =3, 128 filters
        reluLayer();
        convolution2dLayer(2,2); % filter size = 2, 2 filters
        softmaxLayer();
        pixelClassificationLayer()];


% Set the options for network training
options = trainingOptions ('sgdm','MaxEpochs',1);

nbr_epochs = 50; % Number of epochs
append_hard_examples = false; % No hard examples by default
hard_examples = cell (1,1); % initialize cell array of hard examples
hard_labels = zeros (1,1); % initialize label array of hard examples

for i = 1:nbr_epochs 
    disp(['iter.' num2str(i)]);
    % Extract 4000 positive examples and 4000 negative examples from the
    % database
    [imgs, labels] = extract_4000_patches_pos_neg (all_pos_examples, ...
                    all_pos_labels, all_neg_examples, all_neg_labels,...
                    hard_examples, hard_labels, append_hard_examples);
    % Train the network
    if i == 1
        net = trainNetwork (imgs, labels, layers, options);
    else 
        % Use layers from previous epochs
        net = trainNetwork (imgs, labels, net.Layers, options);
    end
    % Generate hard examples
    if rem(i,10) == 0 && i ~= 50  % only in indexes 10, 20, 30, 40
        % Look for hard examples in images
        hard_examples = cell (1,1); % re-initialize cell array of all the examples
        hard_labels = zeros (1,1); 
        m = 1;
        disp('Checking hard examples...');
        % Loop generating hard examples (A.3.3)
        for k = 1:40
            image = read_image (strcat ('img_', num2str(k),'.png'));
            cell_mat_name = strcat ('img_', num2str(k),'.mat');
            load (cell_mat_name);
            [hard_examples_temp, hard_labels_temp] = test_fcn (image, net, cells);
            % Store hard examples
            for a = 1:length(hard_examples_temp)
                if ~isempty (hard_examples_temp{a})
                    hard_examples {m} = hard_examples_temp{a};
                    hard_labels (m) = hard_labels_temp(a);
                    m = m + 1;
                end
            end
            append_hard_examples = true; % Ready to train on hard examples
        end  
    end
end
    
save('my_FCN_network.mat', 'net');
disp ('Saved network. Good job!');