function [examples, labels] = get_aug_neg_examples ()
    % GET_AUG_NEG_EXAMPLES is a function that extracts all the negative
    % examples from the images.
    
    examples = cell (1,10); % initialize cell array of all the examples
    labels = zeros (1,10); % initialize array of labels of the examples
    k = 1;
    threshold = 10; 
    for i = 1:40
        % Look into every image
        image = read_image (strcat ('img_', num2str(i),'.png'));
        cell_mat_name = strcat ('img_', num2str(i),'.mat');
        load (cell_mat_name);
        [~, len_centres] = size (cells);
        patch_radius = 14;
        [y_len, x_len, channels] = size (image);
        % Store negative examples
        for m = 1:(len_centres-1)
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
                        for b = 1:12
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
    end
end