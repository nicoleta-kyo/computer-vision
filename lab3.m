%Pre1.

im = teachimage('chess1.bmp');

m = [-1 0 3; -2 0 2; -1 0 1];
newim = convolve2(im, m, 'reflect'); 
imshow(newim); %shows grey levels

%trying out flipping operation
mflip = flipud(fliplr(m));

%using the mask as a filter
%1) zero-mean: mask ignores average grey level of the pixels under it
%and responds only to contrasts in brightness (what we've had before with masks that have zero mean)
figure();
m = m - mean(m(:)); 
newim = convolve2(im, m, 'reflect');
imshow(newim);

%2)normalised cross-correlation
newim2 = normxcorr2(m, newim);
imshow(newim2);

%trying using myself as a mask ----> picks up basically everything - need
%to create more specific mask??
grph = teachimage('group_photo.jpeg');
mask = [0.6328 0.1133 0.07813 0.8594; 0.168 0.04688 0.5391 0.09766; 0.5938 0.4844 0.4492 0.5586; 0.1406 0.4648 0.2305 0.9531];
myface = convolve2(grph, mask, 'valid');
imshow(myface);
mask2 = mask - mean(mask(:));
figure();
imshow(myface);
myface = normxcorr2(mask, myface);
imshow(myface);

%mask as a pointspread function
I = [zeros(2,7); 0 0 0 1 0 0 0; zeros(2,7)];
pspread = convolve2([-1 0 3; -2 0 2; -1 0 1], I, 'valid'); %???nothing happens?

%1.built-in convolution masks

im = teachimage('chess1.bmp');
m = fspecial('gauss', 11,2);
newim = convolve2(im, m, 'valid');
imshow(newim);

figure();
m = fspecial('gauss', 50,10);
newim = convolve2(im, m, 'valid');
imshow(newim);

figure();
m = fspecial('sobel');
newim = convolve2(im, m, 'valid');
imshow(newim);

%2. thresholding and convolution - see edge2.m





