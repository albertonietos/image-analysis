%% PROJECT A
% Authors: Alberto Nieto,  Wilhelm Råbergh, Truggvi Kaspersen

%% A.1 TRAINING


%% Extract and store positive and negative example patches
clear all; close all; clc;
addpath ('dataset');

[examples, labels] = get_all_examples ();

% Plot a few of the images in the dataset
figure()
indexes = randperm (13807,20);
for i = 1:20
    subplot(4,5,i);
    
    imagesc (examples{indexes(i)});
    if labels(indexes(i)) == 1
        title ('Cell');
    else
        title('Not a cell');
    end
    colormap gray
end

%% Train a network for cell detection

% We will use layers = net.Layers for the next epoch
% We use the same 500 positive examples but change the 500 used for the
% negative ones


% See script 'train_cnn.m'

%% A.2 Applying the detector (CNN)
clc; clear all; close all
load('cnn_network.mat');

% Choose a validation image
image = read_as_grayscale('test.png');
% Define stride according to instructions
stride = 4;
% Apply sliding window
response = sliding_cnn(net, image, stride);
% Resize to original size
resize = imresize(response,4);
% Define threshold and gaussian_std
threshold = 0.5;
gaussian_std = 1.0;
% Apply: gaussian filter, threshold, non-maximum suppression
% and remove false maximas
[~,img] = strict_local_maxima (resize(:,:,2), threshold, gaussian_std);
% Plot the final result
figure()
show_with_overlay(image, img > 0.5);
colormap gray;
    
%% A.3 Bonus level

%% A.3.1) Design and train a fully-convolutional neural network

% See 'TRAIN_FCN.m'

%% A.3.2) Use data augmentation when extracting examples

% See  'get_aug_neg_examples.m' and 'get_aug_pos_examples.m'

[all_neg_examples, all_neg_labels] = get_aug_neg_examples ();
% Saved in 'my_neg_examples.m' and 'my_neg_labels.m'

[all_pos_examples, all_pos_labels] = get_aug_pos_examples ();
% Saved in 'my_pos_examples.m' and 'my_pos_labels.m'

%% A.3.3) Loop to generate hard examples

% See 'TRAIN_FCN.m'
% In line 52, the hard examples are generated

%% A.3.4) Sub-pixel precision

% See 'subpixel.m' and next section for checking in next section


%% CHECK fully-convolutional network
clc; clear all; close all
% load('my_old_fcn_network.mat'); % FCN NETWORK WITHOUT HARD EXAMPLES
load('my_FCN_network.mat'); % FCN NETWORK WITH HARD EXAMPLES

% Choose a test image
image = read_image('dataset/img_50.png');
% Define stride according to instructions
stride = 4;
% Apply sliding window
response = sliding_fcn(net, image);
% Resize to original size
resize = imresize(response,4);
% Define threshold and gaussian_std
threshold = 0.5;
gaussian_std = 1.0;
% Apply: gaussian filter, threshold, non-maximum suppression
% and remove false maximas
[maxima,img, filtered] = strict_local_maxima (resize(:,:,2), threshold, gaussian_std);
img = double (img);
img = img (1:260,1:388);
% Plot the final result
figure()
show_with_overlay(image, img > 0.5);
colormap gray;
    
% Improve maximas by using sub-pixel precision
[precision_points] = subpixel(maxima, filtered);
% Plot the final result
figure()
imagesc(image);
hold on;
plot(maxima(1,:),maxima(2,:),'b*')
plot(precision_points(2,:), precision_points(1,:), 'r*');
title('blue is old, red is new')
% axis off


%% Test generation of hard examples
clc; clear all; close all
load('my_fcn_final_network.mat'); % FCN NETWORK WITHOUT HARD EXAMPLES

% Choose a validation image
image = read_image('dataset/img_50.png');

cell_mat_name = strcat ('img_50.mat');
load (cell_mat_name);

% look for hard examples
[hard_examples, hard_labels] = test_fcn (image, net, cells);

% Plot hard examples
figure()
indexes = randperm (6,6);
for i = 1:6
    subplot(4,5,i);
    
    imagesc (hard_examples{indexes(i)});
    if hard_labels(indexes(i)) == 1
        title ('Cell');
    else
        title('Not a cell');
    end
end

%% A.4 FINAL CHECK

clear all; close all; clc

detections = run_detector (img);

