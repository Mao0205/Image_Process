clc,clear;

jetplane='Test_image/Jetplane.bmp';
lake='Test_image/Lake.bmp';
pepper='Test_image/Peppers.bmp';

%doing Histogram Equalization below
img_histogram_equalization(jetplane,'Jetplane');
img_histogram_equalization(lake,'Lake');
img_histogram_equalization(pepper,'Peppers');

img_power_law(jetplane,'Jetplane');
img_power_law(lake,'Lake');
img_power_law(pepper,'Peppers');

img_sharp_with_laplacian_oprater(jetplane,'Jetplane');
img_sharp_with_laplacian_oprater(lake,'Lake');
img_sharp_with_laplacian_oprater(pepper,'Peppers');

function img_sharp_with_laplacian_oprater(img_name,str)
    [img, map]=imread(img_name);

    kernel_include_4_neighbors=[0,-1,0;-1,5,-1;0,-1,0];
    kernel_include_8_neighbors=[-1,-1,-1;-1,9,-1;-1,-1,-1];
    
    s=size(img);
    output_4=zeros(s,'uint8');
    output_8=zeros(s,'uint8');
    
    new_img = zeros(s(1)+2, s(2)+2, 'double');
    new_img(2:s(1)+1, 2:s(2)+1) = img;   
        %apply kernel to the img
        for i=1:s(1)
            for j=1:s(2)
                tmp_4=new_img(i:i+2,j:j+2).*kernel_include_4_neighbors;
                tmp_8=new_img(i:i+2,j:j+2).*kernel_include_8_neighbors;
                
                output_4(i,j)=sum(tmp_4(:));
                output_8(i,j)=sum(tmp_8(:));   
            end
        end
    
        imwrite(output_4,['output/', str, '_laplacian_with_4_neighbors.bmp']);
        imwrite(output_8,['output/', str, '_laplacian_with_8_neighbors.bmp']);
        figure('NumberTitle','off','Name',[str,' - Compare']);

        subplot(1,3,1), imshow(img), title('original');
        subplot(1,3,2), imshow(output_4), title('with_4_neighbors');
        subplot(1,3,3), imshow(output_8), title('with_8_neighbors');
        saveas(gcf,['output/', str, '_compare_laplacian_oprater.jpg']);
end

function img_histogram_equalization(img_name,str)
    [img,map]=imread(img_name);
%     if ~isempty(map)
%         img2 = ind2gray(img,map)
%         img=img2;
%     end
    

    numofpixels=256*256;
    HIm=uint8(zeros(256,256));
    freq=zeros(256,1);
    probf=zeros(256,1);
    probc=zeros(256,1);
    cum=zeros(256,1);
    output=zeros(256,1);
    

    %calculate the frequency of each type of pixel
    %and also calculate its frequency of all image
    for i=1:size(img,1)
        for j=1:size(img,2)
            value=img(i,j);
            freq(value+1)=freq(value+1)+1; 
            probf(value+1)=freq(value+1)/numofpixels;
        end
    end
    
    sum=0;
    no_bins=255;
    
    for i=1:size(probf)
        sum=sum+freq(i);
        cum(i)=sum;
        probc(i)=cum(i)/numofpixels;
        output(i)=round(probc(i)*no_bins);
    end
    
    for i=1:size(img,1)
        for j=1:size(img,2)
            HIm(i,j)=output(img(i,j)+1);
        end
    end
    
    %write out the output image as bmp format
    file_type='bmp';
    imwrite(HIm,['output/',str,'_Histogram_Equalization.',file_type]);
    figure('NumberTitle','off','Name',[str,' - Compare']);
    subplot(1,2,1),imshow(img),title('original');
    subplot(1,2,2),imshow(HIm),title('After');
    saveas(gcf,['output/',str,'_compare_histogram_equalization.jpg']);

    subplot(1,2,1); bar(img);
    title('Before Histogram Equalization');
    subplot(1,2,2); bar(HIm);
    title('After Histogram Equalization');
    
    saveas(gcf,['output/',str,'_compare_histogram_frequency.jpg']);
end


%power-law (gamma) transformation
%output=(1.1 * input)^0.9
function img_power_law(img_name,str)
    [img,map]=imread(img_name);
    
    power_law_img=img;
    power_num=0.9;
    c=1.1;
    for i=1:size(img,1)
        for j=1:size(img,2)
            %power_law_img(i,j)=(c*img(i,j)).^(power);
            power_law_img(i,j)=(c*double(img(i,j))).^(1.2);
        end
    end
    
    file_type='bmp';
    imwrite(power_law_img, ['output/',str, '_Power_Law.',file_type]);
    figure('NumberTitle','off','Name',[str, ' - Compare']);
    subplot(1,2,1), imshow(img), title('original');
    subplot(1,2,2),imshow(power_law_img),title('Power Law');
    saveas(gcf,['output/',str,'_compare_power_law.jpg']);
    
end

