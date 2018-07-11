function [all_images, M] = prepare_data(sample_size, path_to_images_folder)

    %create directory from which to extract the images
    classes_dir = dir(path_to_images_folder);
    
    %load binary matrix
    M = load('predicate-matrix-binary.txt');

    %read all images in a cell
    all_images = cell(50,1);
    for class=1:50
        fprintf(strcat('Reading images from... class ', num2str(class), '\n'));
        %get images for class 'class'
        class_ims_dir = dir(strcat(path_to_images_folder, '\', classes_dir(class+3).name));
        class_ims = cell(ceil((size(class_ims_dir,1)-3)*sample_size),1);
        %read percentage of images by randomly choosing them
        rands = [repelem(1, length(class_ims)) repelem(0,(size(class_ims_dir,1)-3) - length(class_ims))];
        rands = rands(randperm(length(rands)));
        samplecount=1; %control index for array
        for image=1:size(class_ims_dir,1)-3 % -3 because we don't need the first three files in the directory
            if (rands(image)==1) %get only images from the chosen percentage
                im = imread(strcat(path_to_images_folder, '\',  classes_dir(class+3).name, '\', class_ims_dir(image+3).name));
                %convert image to double gray-scale and store
                im = im2double(im);
                im = rgb2gray(im);
                class_ims{samplecount} = im; %add image to cell
                samplecount = samplecount+1;
            end
        end
        all_images{class} = class_ims;
    end
    
end