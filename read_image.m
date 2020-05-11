function img = read_image(path_to_file)
    raw_image = imread(path_to_file); % Read image from graphics file
    img = im2double(raw_image);       % Convert image to double precision
end