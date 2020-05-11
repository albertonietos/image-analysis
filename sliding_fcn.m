function resp = sliding_fcn(net, img)

% Find the receptive field of the network
padding = net.Layers(1).InputSize;

padded_img = pad_image(img, padding);

% Run the fully-convolutional network
[~, ~, resp]=semanticseg(padded_img, net);