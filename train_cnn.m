clear all; close all; clc
addpath ('dataset');

% Extract all the positive examples
[all_pos_examples, all_pos_labels] = get_aug_pos_examples ();
% Get all the negative examples
[all_neg_examples, all_neg_labels] = get_aug_neg_examples ();

% Original architecture of the CNN
layers = [
            imageInputLayer([29 29 1]);
            convolution2dLayer(5,10);
            reluLayer();
            maxPooling2dLayer(2,'stride',2);
            convolution2dLayer(5,20);
            reluLayer();
            fullyConnectedLayer(2);
            softmaxLayer();
            classificationLayer()];

% Set the options for network training
options = trainingOptions ('sgdm','MaxEpochs',1,...
                           'Shuffle','every-epoch',...
                           'ExecutionEnvironment','gpu');

nbr_epochs = 50; % Number of epochs
for i = 1:nbr_epochs 
    [imgs, labels] = extract_4000_patches_pos_neg (all_pos_examples, ...
                            all_pos_labels, all_neg_examples, all_neg_labels);
    % Train the network
    if i == 1
        net = trainNetwork (imgs, labels, layers, options);
    else 
        % Use layers from previous epochs
        net = trainNetwork (imgs, labels, net.Layers, options);
    end
end
    
% Save CNN network
save('cnn_network.mat', 'net');