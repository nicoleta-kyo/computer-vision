%2.Histogram Equalization exercise


im = teachimage('chess1.bmp');

%initialise histogram
myhist = [];
for i = 1:256
    myhist(i) = 0;
end

%create pdf (compute histogram)
for x = 1:size(im,1)
    for y = 1:size(im,2)
        greylevel = uint8(im(x,y)*255);
        myhist(greylevel) = myhist(greylevel) + 1;
    end
end

%compute cdf
cdf = [];
cdf(1) = myhist(1);
for i = 2:256
    cdf(i)= cdf(i-1) + myhist(i);
end

%normalise cdf
for i = 1:256
    cdf(i) = cdf(i)/(size(im,1)*size(im,2));
end

%remap pixels
new_im = im;
for x = 1:size(new_im,1)
    for y = 1:size(new_im,2)
        greylevel = uint8(new_im(x,y)*255);
        new_im(x,y) = 255*cdf(greylevel)+1;
        new_im(x,y) = round(new_im(x,y));
    end
end


%3.a) horizontal differencing

dif_im = im;
imzhoz = [zeros(size(im,1),1), im];

for x = 1:size(imzhoz,1)
    for y = 1:size(imzhoz,2)-1
        dif_im(x,y) = imzhoz(x,y+1)-imzhoz(x,y);
    end
end

%b) thresholding for bright edges

t_br = 0.3;
dif_im2 = dif_im;
for x = 1:size(dif_im2,1)
    for y = 1:size(dif_im2,2)
        if dif_im2(x,y) > t_br;
            dif_im2(x,y) = 1;
        else
            dif_im2(x,y) = 0;
        end
    end
end

%c and d) thresholding for dark edges - does the opposite of that for bright
%edges - what am i doing wrong?? ---> threshold can't be negative!

%t_da = -0.3;
t_da = 0.1;
difhoz_edges = dif_im;
for x = 1:size(difhoz_edges,1)
    for y = 1:size(difhoz_edges,2)
        if difhoz_edges(x,y) > t_da && difhoz_edges(x,y) < t_br 
            difhoz_edges(x,y) = 1; %make white
        else
            difhoz_edges(x,y) = 0; %make black
        end
    end
end

%e) vertical differencing + thresholding
difver_im = im;
imzver = [zeros(1, size(im,2)); im];
for i=1:size(im,1)-1
    for j=1:size(im,2)
        difver_im(i,j) = imzver(i+1,j) - imzver(i,j);
    end
end

difver_edges = difver_im;
for i=1:size(difver_edges,1)
    for j=1:size(difver_edges,2)
        if difver_edges(i,j) > t_da && difver_edges(i,j) < t_br
            difver_edges(i,j) = 1.5;
        else
            difver_edges(i,j) = 0;
        end
    end
end

%f) combine d and e

diffin = zeros(507, 675);
for i=1:size(diffin,1)
    for j=1:size(diffin,2)
        if difhoz_edges(i,j) ~= 0 || difver_edges(i,j) ~= 0
        diffin(i,j) = max(difhoz_edges(i,j), difver_edges(i,j));
        end
    end
end

%4. Make edge detector a function - look at edget.m

%5. Image smoothing

difsm = [zeros(1, size(im,2)); im];

for i=1:5
    difsm = difsm;
    for x = 1:size(difsm,1)
        for y = 1:size(difsm,2)-1
            difsm(x,y) = (difsm(x,y+1)+difsm(x,y))/2;
        end
    end
    i = i+1;
end

%6. Introduction to convolution

hordifmask = [-1 1];
newimage = convolve2(im, hordifmask, 'valid'); %valid means make new image one column smaller
imshow(newimage, []);

verdifmask = [-1; 1];
newimage = convolve2(im, verdifmask, 'valid'); %valid means make new image one column smaller
imshow(newimage, []);

smoothmask = [1 1; 1 1];
newimage2 = convolve2(im, smoothmask, 'valid');
imshow(newimage2, []);

%7.

%smoothing - how is it different from the other smoothing one?
m1 = [0.5 0.5];
newim1 = convolve2(im, m1, 'valid');
imshow(newim1);

%smoothing + horizontal differencing
m2 = [-1 -2 0 +2 +1];
newim2 = convolve2(im, m2, 'valid');
imshow(newim2);

%make brighter
m3 = [2 2];
newim3 = convolve2(im, m3, 'valid');
imshow(newim3);

%sobel operator
m4 = [-1 0 1; -2 0 2; -1 0 1];
newim4 = convolve2(im, m4, 'valid');
imshow(newim4);

m5 = [-1 -1; -1 3];
newim5 = convolve2(im, m5, 'valid');
imshow(newim5);

%average filter
a = [1/9 1/9 1/9]
m6 = [a;a;a]
newim6 = convolve2(im, m6, 'valid');
imshow(newim6);

%8. The origin -- ??

h1 = [1 1.];
newim7 = convolve2(im, h1, 'same');
imshow(newim7);

%9.

e = edge(im, 'canny');
imshow(e);

e = edge(im, 'canny', 0.4);
imshow(e);

e = edge(im, 'canny', 0.4, 1);
imshow(e);

e = edge(im, 'canny', 0.4, 5);
imshow(e);

e = edge(im, 'sobel');
imshow(e);

e = edge(im, 'prewitt', 'horizontal');
imshow(e);

figure();
e = edge(im, 'prewitt', 'horizontal', 'nothinning');
imshow(e);
