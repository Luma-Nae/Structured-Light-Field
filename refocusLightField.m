% -2:0.5:1
%   load('LightField4D.mat');
%   drawLightField4D(lightField);
%   imshow(refocusLightField(lightField,-2));
%   animateLightField

close all
clear all

load('LightField4D.mat')

[Iout,lfout]=rfLF(lightField,0); % (array of images, depth of focal plane (kernel pixel size)) 
image(Iout)


% 1st entry lightField = camera y
% 2nd entry lightField = camera x
% 3rd entry lightField = pixel row of image
% 4th entry lightField = pixel column of image
% 5th entry lightField = color channel 

% Iout and LightFieldOut are matrices
function [Iout lightFieldOut] = rfLF(lightField, pixels) % [z,t] = f(x,y)
    
    Iout = zeros([size(lightField,3) size(lightField,4) 3]); %matrix full of zeros with the same size of the images
    
    %XX and YY are matrices with the same dimension (size of the image)
    %to access each pixel position
    [XX, YY] = meshgrid(1:size(lightField,4), 1:size(lightField,3)); % creates a vector- from 1 until the size of the 4rth entry of the lightField vector / from 1 the 3rd entry of the lightField vector
    
    %cameras go from 1 to 5 in the x and y direction
    for ky=1:size(lightField,1) %ky = different positions of the camera in the y direction / 1= length of first dimension of the LF vector
        for kx=1:size(lightField,2) %kx = positions of the camera in the x direction / 2= length of second dimension of the LF vector

               %taking one image that corresponds to the camera position kx and ky
            II = reshape(lightField(ky,kx,:,:,:), [size(lightField,3) size(lightField,4) 3] );  %(ky,kx,:,:,:)=(row camera, column camera, row image, column image, chanel)
            %reshape= reordenate the vector and take off the camera
            %dimensions / size(lightField,3): takes the length of the 3rd component in the lightField vector 
            
            for k=1:3
                I(:,:,k) = interp2(XX,YY,II(:,:,k), XX + pixels*(kx-(floor(size(lightField,2)/2)+1)), YY - pixels*(ky-(floor(size(lightField,1)/2)+1)), 'linear', 1);
            end
            Iout = Iout + (1/(size(lightField,2)*size(lightField,1))) .* I;
            
            if nargout>1
                lightFieldOut(ky,kx,:,:,:) = reshape(I, [1 1 size(lightField,3) size(lightField,4) 3]);
            end
        end
    end
    lightFieldOut
end
