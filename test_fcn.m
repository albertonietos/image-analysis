function [hard_examples, hard_labels] = test_fcn (image, net, cells)
    % TEST_FCN is a function that applies the detector on an image an
    % outputs the points where there have been mistakes in order to
    % reinforce the training in those specific points.

    % cells = matrix with the cell centres

    patch_radius = 14;
    hard_examples = cell (1,1); % initialize cell array of all the examples
    hard_labels = zeros (1,1); % initialize array of labels of the examples
    k = 1;
    [y_len, x_len, ~] = size (image);
    % Apply sliding window
    response = sliding_fcn(net, image);
    % Resize to original size
    resize = imresize(response,4);
    % Define threshold and gaussian_std
    threshold = 0.5;
    gaussian_std = 1.0;
    % Apply: gaussian filter, threshold, non-maximum suppression
    % and remove false maximas
    [maxima, ~] = strict_local_maxima (resize(:,:,2), threshold, gaussian_std);

    % Maxima [rows, cols] is where we are guessing there is a cell center

    cells = ceil(cells); % Round cell locations
    threshold_correct = 7; 

    for i = 1:length(maxima)
        % Check that every guess is correct or not
        % Check for every center in the matrix
        residual = 10e5;
        for j = 1:length(cells)
            distance = sqrt ((maxima(1,i)-cells(1,j))^2 + (maxima(2,i)-cells(2,j))^2);
            if distance < residual
                residual = distance; % Store smallest residual
            end
        end
        if residual > threshold_correct
            % It is a bad guess, create negative example
            x = maxima(1,i);
            y = maxima(2,i);
            if (x > patch_radius) && (x < x_len - patch_radius)
                if (y > patch_radius) && (y < y_len - patch_radius)
                    neg_example = get_patch (image, x, y, patch_radius);
                    hard_examples {k} = neg_example; 
                    hard_labels (k) = 0;
                    k = k + 1;
                end
            end
        end
    end
end