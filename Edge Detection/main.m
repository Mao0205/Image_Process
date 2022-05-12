clc,clear;

image1 = "Test_image/image1.jpg";
image2 = "Test_image/image2.jpg";
image3 = "Test_image/image3.jpg";

edge_detect_sobel(image1,'image1');
edge_detect_sobel(image2,'image2');
edge_detect_sobel(image3,'image3');

edge_detect_LoG(image1,'image1');
edge_detect_LoG(image2,'image2');
edge_detect_LoG(image3,'image3');

function edge_detect_sobel(path,name) 
    image = imread(path);

    gxx = [-1,0,1 ; -2,0,2 ; -1,0,1];
    gyy = [1,2,1 ; 0,0,0 ; -1,-2,-1];

    s = size(image);
    new_image = zeros(s(1)+2,s(2)+2,'double');
    new_image(2:s(1)+1, 2:s(2)+1) = image;

    for i = 1:s(1)
        for j = 1:s(2)
            gx = new_image(i:i+2 , j:j+2) .* gxx;
            gy = new_image(i:i+2 , j:j+2) .* gyy;
            temp = abs(abs(sum(gx(:))) + abs(sum(gy(:))));
            if temp > 200
                g(i,j) = 1;
            else
                g(i,j) = 0;
            end
        end
    end

    imwrite(g,['output/',name,'_sobel.jpg']);      
end

function edge_detect_LoG(path,name) 
    image = imread(path);

    %LoG = [0,-1,0 ; -1,4,-1 ; 0,-1,0];
    LoG = [1,1,1 ; 1,-8,1 ; 1,1,1];

    s = size(image);
    new_image = zeros(s(1)+2,s(2)+2,'double');
    new_image(2:s(1)+1, 2:s(2)+1) = image;

    for i = 1:s(1)
        for j = 1:s(2)
            gx = new_image(i:i+2 , j:j+2) .* LoG;
            temp = sum(gx(:));
            if temp > 70
                g(i,j) = 1;
            else
                g(i,j) = 0;
            end
        end
    end

    %figure(3),imshow(g);

    imwrite(g,['output/',name,'_LoG.jpg']);      
end

