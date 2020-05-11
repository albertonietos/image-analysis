function [examples, labels] = get_aug_pos_examples ()
    % GET_AUG_POS_EXAMPLES is a function that extracts all the positive
    % examples from the images.
    
    examples = cell (1,10); % initialize cell array of all the examples
    labels = zeros (1,10); % initialize array of labels of the examples
    k = 1;
    for i = 1:40
        % Look into every image
        image = read_image (strcat ('img_', num2str(i),'.png'));
        cell_mat_name = strcat ('img_', num2str(i),'.mat');
        load (cell_mat_name);
        [~, len_centres] = size (cells);
        patch_radius = 14;
        % Store positive examples
        for j = 1:len_centres
            % We get all the center of cells
            x = ceil (cells (1,j));
            y = ceil (cells (2,j));
            [y_len, x_len, ~] = size (image); % rows, cols, channels
            if (x > patch_radius) && (x < x_len - patch_radius)
                if (y > patch_radius) && (y < y_len - patch_radius)
                    pos_example = get_patch (image, x, y, patch_radius);
                    examples {k} = pos_example; 
                    labels (k) = 1;
                    k = k + 1;
                    for a = 1:10
                        % Create an augmented patch
                        pos_example = new_get_patch (image, x, y, patch_radius);
                        examples {k} = pos_example; 
                        labels (k) = 1;
                        k = k + 1;
                    end
                end
            end
        end
    end
end