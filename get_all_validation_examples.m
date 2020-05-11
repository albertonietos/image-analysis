function [examples, labels] = get_all_validation_examples ()

    examples = cell (1,10); % initialize cell array of all the examples
    labels = zeros (1,10); % initialize array of labels of the examples
    k = 1;
    for i = 41:50
        % Look into every image
        image = read_as_grayscale (strcat ('img_', num2str(i),'.png'));
        cell_mat_name = strcat ('img_', num2str(i),'.mat');
        load (cell_mat_name);
        [rows cols] = size (cells);
        patch_radius = 14;
        % Store positive examples
        for j = 1:cols
            % We get all the center of cells
            x = ceil (cells (1,j));
            y = ceil (cells (2,j));
            [y_len, x_len, channels] = size (image); % rows, cols, channels
            if (x > patch_radius) && (x < x_len - patch_radius)
                if (y > patch_radius) && (y < y_len - patch_radius)
                    pos_example = get_patch (image, x, y, patch_radius);
                    examples {k} = pos_example; 
                    labels (k) = 1;
                    k = k + 1;
                end
            end
        end
        % Store negative examples
        for m = 1:(cols-1)
            % We get the center of backgrounds in between cells
            x = ceil ((cells (1,m) + cells (1,m+1))/2);
            y = ceil ((cells (2,m) + cells (2,m+1))/2);
            if (x > patch_radius) && (x < x_len - patch_radius)
                if (y > patch_radius) && (y < y_len - patch_radius)
                    neg_example = get_patch (image, x, y, patch_radius);
                    examples {k} = neg_example; 
                    labels (k) = 0;
                    k = k + 1;
                end
            end
        end
    end
end