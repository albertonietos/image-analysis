function [subPixel] = subpixel(coord, img)
    % SUBPIXEL is a function that inputs the maxima from the detector and
    % improves the sub-pixel accuracy.
    
    [r,c,~] = size(img);
    % Define length of rows and columns
    row = coord(2,:);
    col = coord(1,:);
    % define new vectors vector
    subRow = zeros(1,length(row));
    subCol = zeros(1,length(col));

    % Counter for valid extrema
    m = 0;
    l = 0;
    o = 0;

    for i = 1:length(coord)

        % Make sure pixel is not too close to edge
        if row(i) > 2 && row(i) < r-1 && ...
                col(i) > 2 && col(i) < c-1

            % Compute partial derivatives via finite differences

            % 1st derivatives
            dimgdrow = (img(row(i)+1,col(i)) - img(row(i)-1,col(i)))/2;
            dimgdcol = (img(row(i),col(i)+1) - img(row(i),col(i)-1))/2;

            D = [dimgdrow; dimgdcol]; % Column vector of derivatives

            % 2nd Derivatives
            d2imgdrow2 = img(row(i)+1,col(i)) - 2*img(row(i),col(i)) + img(row(i)-1,col(i));
            d2imgdcol2 = img(row(i),col(i)+1) - 2*img(row(i),col(i)) + img(row(i),col(i)-1);

            d2imgdrowdcol = (img(row(i)+1,col(i)+1) - img(row(i)+1,col(i)-1) - img(row(i)-1,col(i)+1) + img(row(i)-1,col(i)-1))/4;

            % Form Hessian from 2nd derivatives
            H = [d2imgdrow2  d2imgdrowdcol
                d2imgdrowdcol d2imgdcol2 ];
            % Solve for the increment in sub-pixel accuracy
            delta = -H\D;   % dx is location relative to centre pixel

            if all(abs(delta) <= 1)
                m = m + 1;
                subRow(i) = row(i) + delta(1);
                subCol(i) = col(i) + delta(2);
            else
                l = l + 1;
                subRow(i) = row(i);
                subCol(i) = col(i);
            end

        else
            o = o + 1;
            subRow(i) = row(i);
            subCol(i) = col(i);
        end
    end
    subPixel = [subRow; subCol];
end


