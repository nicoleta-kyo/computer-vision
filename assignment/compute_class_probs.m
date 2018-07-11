function [probs_class, ground_truth_class] = compute_class_probs(probs_attr, test_set, test_set_array, M)

    fprintf('Computing class probabilities... \n');
    
    probs = probs_attr';
    
    probs_images = cell(size(test_set_array,1),10);  
    for image = 1:size(test_set_array,1)
        %compute probability or image to be of a test class
        for counter_test_set = 1:length(test_set(:,2))   
            class = test_set{counter_test_set,2};   %get actual number of class in order to access M
            prob_im = 1;
            %go through all attribute values for that class
            for attribute=1:85
                if (M(class, attribute) == 1)
                    prob_im = prob_im*probs{image,attribute}(2);  %if the class has the attribute, get second score
                else
                    prob_im = prob_im*probs{image,attribute}(1);   %otherwise, get first score
                end    
            end
            probs_images{image,counter_test_set} = prob_im;  %store the prob the image is in that class
        end
    end
    
    %compute ground_truth by taking the real classes of the test images
    ground_truth = [];
    for class=1:10
        ground_truth = [ground_truth repelem(test_set{class,2}, size(test_set{class},1))];
    end
    
    probs_class=probs_images';
    ground_truth_class = ground_truth';

end