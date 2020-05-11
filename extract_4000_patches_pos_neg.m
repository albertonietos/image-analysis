function [imgs, labels] = extract_4000_patches_pos_neg (all_pos_examples, ...
                            all_pos_labels, all_neg_examples, all_neg_labels,...
                            hard_examples, hard_labels, append_hard_examples)
    % EXTRACT_4000_PATCHES_POS_NEG is a function that extracts 4000
    % positive examples and 4000 negative examples to train a neural
    % network.
    neg_examples    = cell (1,10);
    neg_labels      = zeros (1,10); 
    pos_examples    = cell (1,10);
    pos_labels      = zeros (1,10); 

    % Choose 4000 random negative examples to train the network with
    indexes = randperm (length(all_neg_examples),4000);
    for j = 1:4000
        prob = rand(1); % Probability of choosing a hard example (20%)
        if prob > 0.8 && append_hard_examples
            index_hard = randperm (length(hard_examples),1);
            neg_examples {j} = hard_examples {index_hard};
            neg_labels (j) = hard_labels (index_hard);
        else
            neg_examples {j} = all_neg_examples {indexes(j)};
            neg_labels (j) = all_neg_labels (indexes(j));
        end
    end
    
    % Choose 4000 random positive examples to train the network with
    indexes = randperm (length(all_pos_examples),4000);
    for j = 1:4000
        pos_examples {j} = all_pos_examples {indexes(j)};
        pos_labels (j) = all_pos_labels (indexes(j));
    end
    % Store positive examples
    labels = [];
    for k = 1:length(pos_examples)
        examples{k} = pos_examples{k};
        labels(k) = pos_labels(k);
    end
    % Store negative examples
    for m = 1:length(neg_examples)
        examples{k} = neg_examples{m};
        labels(k) = neg_labels(m);
        k = k + 1;
    end

    % Make a 4-D array for the images
    imgs = [];
    for k = 1:length(examples)
        imgs (:,:,:,k) = examples{k};
    end
    % Make a categorical array for the labels
    labels = categorical (labels);
end