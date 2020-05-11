function patch = new_get_patch (image, x, y, patch_radius)
    % NEW_GET_PATCH creates a patch centered at coordinate (x,y) with a
    % radius of patch_radius by augmentation of the original data.
    
    % X COORDINATE = Column number
    % Y COORDINATE = Row number
%     dim = size(image);
%     
%     clear all; %close all; clc
%     addpath ('dataset');
%     load ('img_1.mat');
%     
%     image = read_image('img_1.png');
%     
%     x = ceil(cells(1,50));
%     y = ceil(cells(2,50));
%     
%     patch_radius = 14;
    dim = size(image);
    %% Small translation, rotation and scaling
    
    % Random small translation [-2 2]
    t = randi([-1,1],[2,1]); 
    % Random rotation [-pi pi]
    alpha = -pi + 2*pi*rand(1,1);
    % Random scaling factor [0.9 1.1]
    s = 0.9 + 0.2*rand(1,1); 
    % Transformation matrices
    A = s.*[cos(alpha) -sin(alpha);
     sin(alpha)  cos(alpha)];
    % Auxiliary matrices to perform 2D rotation around (x,y)
    aux = [1 0 x;
           0 1 y;
           0 0 1];
    aux2 = [1 0 -x;
            0 1 -y;
            0 0  1];
    % 2D affine geometric transformation
    T = inv(aux*[A t; 0 0 1]*aux2);
    aff_T = affine2d(T');
    output_view = imref2d(dim);
    for i = 1:3
        warped(:,:,i) = imwarp(image(:,:,i), aff_T, 'OutputView', output_view);
    end
    
    %% Intensity variation
    bright = 0.9 + 0.2*rand(1,1); 
    warped = bright .* warped;
    
    %% Extract the augmented patch
    patch = get_patch (warped, x, y, patch_radius);
%     try
%         row = (y - patch_radius):(y + patch_radius);
%         col = (x - patch_radius):(x + patch_radius);
%         channels = 3; % grayscale
%         patch = warped (row, col, 1:channels);
% %         patch_orig = image (row, col, 1:channels);
%         % The variable patch chooses all elements of the image bounded by
%         % the center coordinates and the patch_radius.
%     catch
%         error(' #### Patch outside image borders ####');
%         % An error is displayed if the patch is outside the image borders.
%     end
    
%     figure()
%     imagesc(warped)
%     hold on
%     plot (x,y, 'r*')
%     
%     figure()
%     subplot(2,1,1); imagesc(patch_orig); title('orig');
%     subplot(2,1,2); imagesc(patch); title('new');
%     colormap gray
end