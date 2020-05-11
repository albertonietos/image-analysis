function img = read_as_grayscale(path_to_file)
    img = read_image(path_to_file); % Reads the image & converts it to double precision
    img = mean(img,3);              % Computes the grayscale image (mean)
end