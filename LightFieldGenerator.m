clear all

files = dir('*.JPG'); % list all images in your path

%loop through and access files 
%create empty matrix and assign each entry to a file x and y


count=1;
for y=1:2  %1 until the number of rows of the light field
    for x=1:11  % 1 until the number of columns of the light field
        img2 = imread(files(count).name); % read each image and do what you want
        img= im2double(img2);
        resized = imresize(img, 0.5);
        lightField(:,:,:,y,x) = resized;
        count=count+1
    end
end


%%
%display the light field
for y=1:2
    for x=1:11
        imshow(lightField(:,:,:,y,x))
    end
end
