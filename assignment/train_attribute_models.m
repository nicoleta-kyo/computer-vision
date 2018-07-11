function [models, test_set, test_set_array]= train_attribute_models(all_images, all_feats, all_feats_array, num_clusters, M)

    fprintf('Kmeans...')
    %%%%%%%%%%%do kmeans with chosen number of clusters%%%%%%%%%%%%%
    [indx,C] = kmeans(all_feats_array, num_clusters);

    
    %create a histogram for an image
    start = 0;
    hist_index = 0;
    for class=1:50
        fprintf(strcat('Creating histograms using extract_bag_of_features... class', num2str(class), '\n'));
        for image=1:size(all_feats{class,1},1)
            size_image = size(all_feats{class,1}{image,1},1);
            hist_index = hist_index + 1;
            %get the features for the image
            im = indx(start+1:start+size_image,1);
            %create a histogram for the image
            hist = extract_bag_of_visual_features(im);  
            %divide by size of image and store the histogram in an array
            bow_features(hist_index,:) = hist.Values/size_image;
            start = start+size_image;            
        end
    end
    

    %read classes files
    train_classes = textread('trainclasses.txt', '%s');
    [nums, classes] = textread('classes.txt', '%u %s');


    %separate train and test data
    start=0;
    train_set = {};
    train_counter = 1;
    test_set = {};
    test_counter = 1;
    num_train_hists = 0;   %count number of histograms in train set
    num_test_hists = 0;   %count number of histograms in test set
    for class=1:50
        fprintf(strcat('Separating train and test data for... class', num2str(class), '\n'));
        train=false;
        size_class = size(all_images{class,1},1);
        %loop thorough train classes to see if the class is for training
        for train_class=1:40
            %if train class, add to train set and stop the loop
            if strcmp(classes{class,1}, train_classes{train_class,1})
                train_set{train_counter,1} = bow_features(start+1:start + size_class,:);
                train_set{train_counter,2} = class;
                start = start+ size_class;
                train = true;                
                num_train_hists = num_train_hists + size_class;    %update count of train histograms
                train_counter = train_counter+1;
                break;
            end  
        end
        %if the class was not in the train classes, has to be in the test set
        if (train == false)
            test_set{test_counter,1} = bow_features(start+1:start + size_class,:);
            test_set{test_counter,2} = class;
            start = start + size_class;
            num_test_hists = num_test_hists + size_class;    %update count of test histograms
            test_counter = test_counter +1;
        end
    end
    
    %concatenate test_set in an array
    start = 0;
    test_set_array = zeros(num_test_hists,128);
    for i=1:10
        test_set_array(start+1:start+size(test_set{i,1},1),:) = test_set{i,1};
        start = start + size(test_set{i,1},1);
    end
    

    %build classifiers
    models = cell(85,1);
    for attribute=1:85
        fprintf(strcat('Building classifier No.', num2str(attribute), '...\n'));
        hist_counter = 1;
        hists = zeros(num_train_hists,128);
        start = 0;
        labels = [];     
        for class=1:50
            %check if class is part of train set
            if (ismember(class, [train_set{:,2}]))
                %add histograms of that class to table with predictors
                hists(start+1:start+size(train_set{hist_counter,1},1),:) = train_set{hist_counter,1};
                if (M(class,attribute) == 1)  %if the class has the attribute, add number of labels '1' as big as the number of images for this class
                    labels = [labels repelem(1, size(train_set{hist_counter,1},1))];
                else                          %else, add number of labels '0'
                    labels = [labels repelem(0, size(train_set{hist_counter,1},1))];
                end 
                start = start + size(train_set{hist_counter,1},1);
                hist_counter = hist_counter +1;
            end
        end
        Y = labels';
        %build the model for the attribute
        model = fitcsvm(hists, Y);
        models{attribute} = fitSVMPosterior(model);
    end
    

end