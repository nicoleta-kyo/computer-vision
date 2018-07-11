
%add folders and subfolders
addpath(genpath('\\smbhome.uscs.susx.ac.uk\nk331\Documents\MATLAB\computer vision\assignment'));
path_to_images_folder = '\\smbhome.uscs.susx.ac.uk\nk331\Documents\MATLAB\computer vision\assignment\Animals_with_Attributes2\JPEGImages';

%paramaters to optimise
sample_size = 0.25;
num_clusters = 250;
strongest_feat = 0.95;

%workflow
[all_images, M] = prepare_data(sample_size, path_to_images_folder);
[all_feats, all_feats_array] = get_image_features(all_images, strongest_feat);
[models, test_set, test_set_array]= train_attribute_models(all_images, all_feats, all_feats_array, num_clusters, M);
probs_attr = compute_attribute_probs(models, test_set_array);
[probs_class, ground_truth_class] = compute_class_probs(probs_attr, test_set, test_set_array, M);
acc = compute_accuracy(probs_class, ground_truth_class, test_set);

