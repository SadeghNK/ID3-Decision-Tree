close all;
clear;
clc;

%%=========================== part 1 - build tree ========================
data_list = dir('datasets\');
path(1:6, 1) = "";
for I = 1:6
    path(I, 1) = data_list(I+2).folder +"\"+ data_list(I+2).name;
end

monk1_test = data_read(path(1));
monk1_train = data_read(path(2));

monk2_test = data_read(path(3));
monk2_train = data_read(path(4));

monk3_test = data_read(path(5));
monk3_train = data_read(path(6));

% backup1 = monk1_train;
% backup2 = monk2_train;
% backup3 = monk3_train;


% attributes = {{1,2,3}; {1,2,3}; {1,2}; {1,2,3};{1,2,3,4};{1,2}};
monk1_tree = ID3_buildtree(monk1_train, 0);
monk2_tree = ID3_buildtree(monk2_train, 0);
monk3_tree = ID3_buildtree(monk3_train, 0);


monk1_results = nan(432,1);
monk2_results = nan(432,1);
monk3_results = nan(432,1);
for I = 1:432
    monk1_results(I,1) = ID3_classify(monk1_tree, monk1_test(I,:));
    monk2_results(I,1) = ID3_classify(monk2_tree, monk2_test(I,:));
    monk3_results(I,1) = ID3_classify(monk3_tree, monk3_test(I,:));   
end

acc1 = sum(monk1_results(:,1) == monk1_test(:,end)) / 432 %#ok
acc2 = sum(monk2_results(:,1) == monk2_test(:,end)) / 432 %#ok
acc3 = sum(monk3_results(:,1) == monk3_test(:,end)) / 432 %#ok

