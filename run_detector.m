function detections = run_detector (image)

    load('my_FCN_network.mat'); % FCN NETWORK 
    
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

    % Improve maximas by using sub-pixel precision
    [precision_points] = subpixel(maxima, filtered);
    % Plot the final result
    figure()
    imagesc(image);
    hold on;
    plot(precision_points(2,:), precision_points(1,:), 'r*');
    axis off
    detections = precision_points;
end