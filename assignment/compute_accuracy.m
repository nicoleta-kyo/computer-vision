function acc = compute_accuracy(probs_class, ground_truth_class, test_set)

    probs = probs_class';
    ground_truth = ground_truth_class';
    
    %determine the highest probability
    images_predict = zeros(size(probs,1), 1);
    for image=1:size(probs,1)
        [highest_prob,class_highest] = max([probs{image,:}]);
        class = test_set{class_highest,2};  %get actual number of class
        images_predict(image) = class;
    end

    %compute correct/total
    correct = 0;
    for image=1:length(probs)
        if (images_predict(image) == ground_truth(image))
            correct = correct + 1;
        end
    end
    acc = correct/length(probs);
    fprintf(strcat('Accuracy: ', num2str(acc), '\n'));

end