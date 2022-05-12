clear, clc;

aloe = 'Test_image/aloe.jpg';
church = 'Test_image/church.jpg';
house = 'Test_image/house.jpg';
kitchen = 'Test_image/kitchen.jpg';

RGB_power_law(aloe,'aloe', 2 , 0.5);
RGB_power_law(church,'church', 2 , 0.7);
RGB_power_law(house,'house', 0.7 , 2.5);
RGB_power_law(kitchen,'kitchen', 1 , 2);

HSI_histogram(aloe,'aloe');
HSI_histogram(church,'church');
HSI_histogram(house,'house');
HSI_histogram(kitchen,'kitchen');

Lab_histogram(aloe,'aloe');
Lab_histogram(church,'church');
Lab_histogram(house,'house');
Lab_histogram(kitchen,'kitchen');

function Lab_histogram(path,name)
    imag = imread(path);
    image = rgb2lab(imag);
    L = image(:,:,1);
    a = image(:,:,2);
    b = image(:,:,3);      

    L = adapthisteq(L/100)*100;
    im = cat(3,L,a,b);
    out = lab2rgb(im);
    imwrite(out,['output/',name,'_Lab.jpg']);
    %{
    L = rescale(L,0,255);
    L1 = adapthisteq(L);
    L1 = rescale(L1,0,100);

    out = cat(3,L1,a,b);
    out = lab2rgb(out);
    %}
end

function HSI_histogram(path,name)
    imag = imread(path);
    image = im2double(imag); 
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);      

    % RGB -> HSI
    theta = acos( 0.5*(r-g+r-b) ./ sqrt( ((r-g).^2)+(r-b).*(g-b) ) );
    H = theta;
    H(b > g) = 2*pi - H(b > g); 
    H = H/(2*pi); %not sure
    temp = r+g+b;
    temp(temp == 0) = eps;
    S = 1 - (3.*min(min(r,g),b))./temp;
    H(S == 0) = 0;
    I = (r+g+b)/3;
    hsi = cat(3,H,S,I);

    I1 = histeq(I);

    % HSI -> RGB
    R = zeros(size(hsi, 1), size(hsi, 2)); 
    G = zeros(size(hsi, 1), size(hsi, 2)); 
    B = zeros(size(hsi, 1), size(hsi, 2)); 


    if ((0<=H) & (H<2*pi/3))
        B = I1 .* (1 - S ); 
        R = I1 .* (1+ (S .* cos(H)) ./ cos(pi/3 - H));
        G = 3 * I1 - (R+B);
        
    elseif 2*pi/3<=H & H<4*pi/3
        H = H-2*pi/3;
        R = I1 .* (1 - S ); 
        G = I1 .* (1+ (S .* cos(H)) ./ cos(pi/3 - H));
        B = 3 * I1 - (R+G);

    else
        H = H-4*pi/3;
        G = I1 .* (1 - S ); 
        B = I1 .* (1+ (S .* cos(H)) ./ cos(pi/3 - H));
        R = 3 * I1 - (B+G);
    end
    
    rgb = cat(3,R,G,B);


    imwrite(rgb,['output/',name,'_HSI.jpg']);

end


function RGB_power_law(path,name,c,gamma)
    [img,cmp] = imread(path);
    a = im2double(img);
    b = c*(a.^gamma);
    imwrite(b,['output/',name,'_RGB.jpg']);

    %{
    % can output show the picture%
    subplot(2,2,1),imshow(a);
    subplot(2,2,2),imshow(b);
    subplot(2,2,3),imhist(a);
    subplot(2,2,4),imhist(b);
    %}
end
