function [all_feats, all_feats_array] = get_image_features(all_images, strongest_feat)

    %%%%%%extract features%%%%%%%%%
    all_feats = cell(50,1);
    num_feats=0;
    for class=1:50
        fprintf(strcat('Extracting features from... class ', num2str(class), '\n'));
        size_of_class = size(all_images{class},1);
        class_feats = cell(size_of_class,1);
        %for each class go through each image and extract features
        for image=1:size_of_class
            im = all_images{class,1}{image,1};
            points = detectSURFFeatures(im);
            %get only chosen proportion of features
            num_strongest = ceil(size(im,1)*strongest_feat);
            [features, valid_points] = extractFeatures(im, points.selectStrongest(num_strongest), 'Method', 'SURF','SURFSize', 128);
            class_feats{image} = features;
            num_feats=num_feats+size(features,1);
        end
        all_feats{class} = class_feats;
    end
    
    %%%%%concatenate images for k means%%%%%%%%%%%%%
    start = 0;
    all_feats_array = zeros(num_feats, 128);
    for class=1:size(all_feats,1) 
        fprintf(strcat('Concatenating features from... class ', num2str(class), '\n'));
        for im=1:size(all_feats{class,1},1)
            all_feats_array(start+1:start+size(all_feats{class,1}{im,1}),:) =  all_feats{class,1}{im,1};
            start = start+size(all_feats{class,1}{im,1});
        end
    end

end