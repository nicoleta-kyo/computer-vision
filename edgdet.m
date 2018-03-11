function image = edgdet(im, t1, t2)
%EDGDET detect edges in an image
difhoz_im = im;
im = [zeros(size(im,1),1), im];

%do horizontal thresholding
for x = 1:size(im,1)
    for y = 1:size(im,2)-1
        difhoz_im(x,y) = im(x,y+1)-im(x,y);
    end
end

%detect horizontal edges
t_br = t1;
t_da = t2;
difhoz_edges = difhoz_im;
for x = 1:size(difhoz_edges,1)
    for y = 1:size(difhoz_edges,2)
        if difhoz_edges(x,y) > t_da && difhoz_edges(x,y) < t_br 
            difhoz_edges(x,y) = 1; %make white
        else
            difhoz_edges(x,y) = 0; %make black
        end
    end
end

%do vertical thresholding
difver_im = im;
imzver = [zeros(1, size(im,2)); im];
for i=1:size(im,1)-1
    for j=1:size(im,2)
        difver_im(i,j) = imzver(i+1,j) - imzver(i,j);
    end
end

%detect vertical edges
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

%combine hor and ver edges into one final image
diffin = zeros(507, 675);
for i=1:size(diffin,1)
    for j=1:size(diffin,2)
        if difhoz_edges(i,j) ~= 0 || difver_edges(i,j) ~= 0
        diffin(i,j) = max(difhoz_edges(i,j), difver_edges(i,j));
        end
    end
end
image = diffin;
end
