
index=1;
for p=-30:1:-10 %pixel value
    [Iout]=rfLF(lightField,p); % (array of images, depth of focal plane (kernel pixel size)) 
    anim(:,:,:,index)=Iout; %storing the image
    index=index+1;
    %image(Iout);
end
for p=-10:0.3:-5 %pixel value
    [Iout]=rfLF(lightField,p); % (array of images, depth of focal plane (kernel pixel size)) 
    anim(:,:,:,index)=Iout; %storing the image
    index=index+1;
    %image(Iout);
end



myVideo = VideoWriter('dynamic_refocus7'); %open video file
myVideo.FrameRate = 5;  %can adjust this, 5 - 10 works well for me
open(myVideo)
for i=0:(size(anim,4)-1)
    imshow(anim(:,:,:,i+1))
    pause(0.01) %Pause and grab frame
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
end
close(myVideo)

%%


%[Iout]=rfLF(lightField,); % (array of images, depth of focal plane (kernel pixel size)) 
%imshow(Iout)

% Iout and LightFieldOut are matrices
function [Iout] = rfLF(lightField, pixels) % [z,t] = f(x,y)
    
    Iout = zeros([size(lightField,1) size(lightField,2) 3]); %matrix full of zeros with the same size of the images
    
    %XX and YY are matrices with the same dimension (size of the image)
    %to access each pixel position
    [XX, YY] = meshgrid(1:size(lightField,2), 1:size(lightField,1)); % creates a vector- from 1 until the size of the 2rth entry of the lightField vector / from 1 the 1st entry of the lightField vector  
    
    for ky=1:size(lightField,4) %ky = different positions of the camera in the y direction 
        for kx=1:size(lightField,5) %kx = positions of the camera in the x direction 

           
            II= lightField(:,:,:,ky,kx); 
            for k=1:3
                I(:,:,k) = interp2(XX,YY,II(:,:,k), XX + pixels*(kx-(floor(size(lightField,5)/2)+1)), YY - pixels*(ky-(floor(size(lightField,4)/2)+1)), 'linear', 1); %initial projectioin
            end
            
            Iout = Iout + (1/(size(lightField,4)*size(lightField,5))) .* I;  %average Isa
            %Iout is a single matrix with all images averaged
            
            if nargout>1
                lightFieldOut(:,:,:,ky,kx) = reshape(I, [1 1 size(lightField,3) size(lightField,4) 3]);
            end 
        end
    end
end
