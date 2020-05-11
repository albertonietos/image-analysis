function padded_img = pad_image(img, padding)

% This determines the padding. Note that exactly how much padding we want
% is not an exact science.
ox = floor(padding(2)/2);
oy = floor(padding(1)/2);

% Define the padded image
[sz_y, sz_x, nchannels] = size(img);
padded_img = zeros(sz_y + padding(1), sz_x + padding(2), nchannels);
padded_img(oy + 1:oy + sz_y, ox + 1:ox + sz_x, :) = img;