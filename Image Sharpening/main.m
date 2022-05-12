clear,clc;

moon = 'HW2_test_image/blurry_moon.tif'
skeleton = 'HW2_test_image/skeleton_orig.bmp'

laplacian_spatial(skeleton,'skeleton');
laplacian_spatial(moon,'blurry_moon');
unsharp_spatial(moon,'blurry_moon');
unsharp_spatial(skeleton,'skeleton');

high_boost_spatial(moon,'blurry_moon');
high_boost_spatial(skeleton,'skeleton');

laplacian_freq(moon,'blurry_moon');
laplacian_freq(skeleton,'skeleton');

function laplacian_spatial(image,img_name)
    [img,map] = imread(image);
    
    kernel = [0,-1,0;-1,5,-1;0,-1,0];
    s = size(img);
    
    output_spat = zeros(s,'uint8');  
    
    padding_img_spat = zeros(s(1)+2,s(2)+2,'double');
    padding_img_spat(2:s(1)+1,2:s(2)+1) = img(:,:,1); 
    
    for i = 1:s(1)
        for j = 1:s(2)
            temp_spat = padding_img_spat(i:i+2,j:j+2).*kernel;
            output_spat(i,j) = sum(temp_spat(:));            
        end
    end
    
    s1 = size(output_spat);
    if numel(s1) > 2
        output_spat = rgb2gray(output_spat);
    end
      
    imwrite(output_spat,['output/',img_name,'_laplacian_spatial.bmp']);
end

function unsharp_spatial(image,img_name)
    [img,cmp] = imread(image);
    
    s = size(img);
    
    GAU = fspecial('gaussian',s(1),s(2));
    Blur = imfilter(img,GAU);
    unsharp = img - Blur;
    output_spat = img + unsharp;
    imwrite(output_spat,['output/',img_name,'_unsharp_spatial.bmp']);
 
end
    
function high_boost_spatial(image,img_name)
    [img,map] = imread(image);
    
    A = 1.2;
    kernel = [0,-1,0;-1,A+4,-1;0,-1,0];
    
    s = size(img);
    output_spat = zeros(s,'uint8');  
    
    padding_img_spat = zeros(s(1)+2,s(2)+2,'double');
    padding_img_spat(2:s(1)+1,2:s(2)+1) = img(:,:,1); 
    
    for i = 1:s(1)
        for j = 1:s(2)
            temp_spat = padding_img_spat(i:i+2,j:j+2).*kernel;
            output_spat(i,j) = sum(temp_spat(:));
        end
    end
    
    s1 = size(output_spat);
    if numel(s1) > 2
        output_spat = rgb2gray(output_spat);
    end
    
    imwrite(output_spat,['output/',img_name,'_high_boost_spatial.bmp']);
end

function laplacian_freq(image,img_name)
    [img,cmp] = imread(image);
    
    s = size(img);
    
    fimg = fft2(img);
    output_freq = zeros(s,'uint8'); 
    output = zeros(s(1),s(2),'double');
    
    M = s(1);
    N = s(2);
    
    for i = 1:s(1)
        for j = 1:s(2)
            output(i,j) = fimg(i,j)*(1+(4*pi*pi*((i-M/2)*(i-M/2)+(j-N/2)*(j-N/2))));
        end
    end   
    
    temp = ifft2(output);
    output_freq = real(temp);    
    output_freq = uint8(255 * mat2gray(output_freq));
    
    imwrite(output_freq,[img_name,'_laplacian_freq.bmp']);
end
