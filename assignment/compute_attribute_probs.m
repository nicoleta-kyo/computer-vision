function [probs_attr] = compute_attribute_probs(models, test_set_array)

    %compute attribute probabilities for the models
    fprintf('Computing attribute probabilities... \n');
    probs = cell(size(test_set_array,1), 85);
    for image=1:size(test_set_array,1)
        for attribute=1:85
            [label,scores] = predict(models{attribute}, test_set_array(image,:));
            probs{image, attribute} = scores;
        end
    end
    
    probs_attr = probs';

end