function [bow_feature]  = extract_bag_of_visual_features(image)

    %create histogram out of the features of the image
    bow_feature = histogram(image, 128, 'binLimits', [1 128]);

end