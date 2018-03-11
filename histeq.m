%2. Histogram Equalization exercise


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
        greylevel = uint8(new_im(x,y)*255)+1;
        new_im(x,y) = 255*cdf(greylevel);
        new_im(x,y) = round(new_im(x,y));
    end
end




