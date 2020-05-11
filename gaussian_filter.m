function img = gaussian_filter (image, std)
% GAUSSIAN_FILTER A function that takes in an 'image' and performs a
% Gaussian filtering of that image at a specific standard deviation 'std'.
    h = fspecial('gaussian', 9, std); 
    % The filter created with 8 filter coefficients and specific standard
    % deviation.
    img = imfilter(image, h, 'symmetric');
    % Lastly the the image which is fed into the function is filtered with
    % the Gaussian filter.
end