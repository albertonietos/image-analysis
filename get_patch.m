function patch = get_patch (image, x, y, patch_radius)
    % GET_PATCH Creates quadratic patch centered at coordinate (x,y) and has a
    % radius of patch_radius
    % X COORDINATE = Column number
    % Y COORDINATE = Row number

    try
        row = (y - patch_radius + 1):(y + patch_radius);
        col = (x - patch_radius + 1):(x + patch_radius);
        channels = 3; % channels RGB
        patch = image (row, col, 1:channels);
        % The variable patch chooses all elements of the image bounded by
        % the center coordinates and the patch_radius.
    catch
        error(' #### Patch outside image borders ####');
        % An error is displayed if the patch is outside the image borders.
    end
end