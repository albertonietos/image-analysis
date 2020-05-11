function [maxima, indicator, result] = strict_local_maxima (image, threshold, gaussian_std)
    % STRICT_LOCAL_MAXIMA detects the maxima where the center of the cells
    % are located, thus giving only one detection per cell.
%     figure()
%     subplot(2,3,1); imagesc(image);title('original map of probabilities')
    % Gaussian filter
    img = gaussian_filter (image, gaussian_std);
%     subplot(2,3,2); imagesc(img);title('after gaussian filter')

    % Thresholding to remove false detections
    dim = size(img);
    for i = 1:dim(1)
        for j = 1:dim(2)
            if img (i,j) > threshold
                img (i,j) = img (i,j);
            else
                img (i,j) = 0;
            end
        end
    end   
%     subplot(2,3,3); imagesc(img);title('after threshold')
        % Maximum filter
    result = ordfilt2 (img, 8, ones(3,3));
%     subplot(2,3,4); imagesc(result); title('after maximum filter')
    % Transform to binary (ones (maxima) and zeros)
    indicator = result < img;
%     subplot(2,3,5); imagesc(indicator);title('after img == result')
    % Removes false positives from all zero matrix 
    indicator = (indicator.*image);
%     subplot(2,3,6); imagesc(indicator);title('after indicator & image')
    % Store the indexes of the maxima
    [row_coords, col_coords] = find (indicator);
    x = col_coords;
    y = row_coords;
    maxima = [x, y].'; % row = y, col = x
end
