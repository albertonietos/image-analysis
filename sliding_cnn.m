function response = sliding_cnn(net, img, stride)

    % Find the receptive field of the network
    input_sz = net.Layers(1).InputSize;

    padded_img = pad_image(img, input_sz);

    % Find the receptive field of the network
    output_sz = [ceil(size(img,1)/stride), ceil(size(img,2)/stride), 2];

    % Allocate a matrix for the output
    response = zeros(output_sz(1), output_sz(2), output_sz(3));

    for x = 1:output_sz(2)
        for y = 1:output_sz(1)
            patch = get_patch_padded(padded_img, (x-1)*stride, (y-1)*stride, input_sz);
            response(y, x, :) = net.predict(patch);
        end
    end
end


function patch = get_patch_padded(padded_img, x, y, input_sz)

    start_row = y + 1;
    start_col = x + 1;

    stop_row = y + input_sz(1);
    stop_col = x + input_sz(2); 

    patch = padded_img(start_row:stop_row, start_col:stop_col, :);
end