function [imgs, labels] = get_augmented_training_examples (image, cells, patch_radius)
    % GET_AUGMENTED_TRAINING_EXAMPLES is a function that creates the 
    % training data for an epoch from an input image in which we perform
    % data augmentation.
    
    [~, cols] = size (cells);
    [y_len, x_len, channels] = size (image); % rows, cols, channels
    
    examples = cell (1,10); % initialize cell array of all the examples
    labels = zeros (1,10); % initialize array of labels of the examples
    k = 1;
    threshold = 10; % If patches aren't spaced this match (pixels) in between, 
                    % don't take negative examples
    % Store positive examples
    for i = 1:cols
        % We get all the center of cells
        x = ceil (cells (1,i));
        y = ceil (cells (2,i));
        if (x > patch_radius) && (x < x_len - patch_radius)
            if (y > patch_radius) && (y < y_len - patch_radius)
                % Store original patch
                pos_example = get_patch (image, x, y, patch_radius);
                examples {k} = pos_example;
                labels (k) = 1;
                k = k + 1;
                for a = 1:25
                    % Create an augmented patch
                    pos_example = new_get_patch (image, x, y, patch_radius);
                    examples {k} = pos_example; 
                    labels (k) = 1;
                    k = k + 1;
                end
            end
        end
    end
    clear x y
    % Store negative examples
    for m = 1:(cols-1)
        % We get the center of backgrounds in between cells
        x = ceil ((cells (1,m) + cells (1,m+1))/2);
        y = ceil ((cells (2,m) + cells (2,m+1))/2);
        distance = sqrt((cells (1,m+1) - cells (1,m))^2 + (cells (2,m+1) - cells (2,m))^2);
        if distance > threshold
            if (x > patch_radius) && (x < x_len - patch_radius)
                 if (y > patch_radius) && (y < y_len - patch_radius)
                    neg_example = get_patch (image, x, y, patch_radius);
                    examples {k} = neg_example; 
                    labels (k) = 0;
                    k = k + 1;
                    for b = 1:27
                        % Create an augmented patch
                        neg_example = new_get_patch (image, x, y, patch_radius);
                        examples {k} = neg_example; 
                        labels (k) = 0;
                        k = k + 1;
                    end
                 end
            end
        end
    end
    
    
    % Make a 4-D array for the images
    imgs = [];
    for n = 1:length(examples)
        imgs (:,:,:,n) = examples{n};
    end
    % Make a categorical array for the labels
    labels = categorical (labels);
% imgs = examples;
end