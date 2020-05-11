function show_with_overlay(img, overlay)

rgb = zeros(size(overlay,1), size(overlay,2), 3);
rgb(:,:,1) = 1;
imagesc(rgb); 

hold on 
% Save the handle for later use 
h = imagesc(img); 
hold off
alpha = 1-overlay; 
set(h, 'AlphaData', alpha);
axis image
axis off