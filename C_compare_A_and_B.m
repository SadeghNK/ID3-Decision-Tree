close all;
clear;
clc;

%%=========================== part 2 - REP pruning ========================

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

% validation_size = 0.3;
S = 1;
for J = 0.1:0.1:0.65
    
    validation_size(S) = J;
    
    val_size1 = floor(length(monk1_train) * validation_size(S));
    [prune_set1, index1] = datasample(monk1_train, val_size1, 'Replace', false);
    monk1_train(index1, :) = [];

    val_size2 = floor(length(monk2_train) * validation_size(S));
    [prune_set2, index2] = datasample(monk2_train, val_size2, 'Replace', false);
    monk2_train(index2, :) = [];

    val_size3 = floor(length(monk3_train) * validation_size(S));
    [prune_set3, index3] = datasample(monk3_train, val_size3, 'Replace', false);
    monk3_train(index3, :) = [];

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

    acc1 = sum(monk1_results(:,1) == monk1_test(:,end)) / 432;
    acc2 = sum(monk2_results(:,1) == monk2_test(:,end)) / 432;
    acc3 = sum(monk3_results(:,1) == monk3_test(:,end)) / 432;

    %%============================== pruning ============================

    clear path
    path(1) = "old_tree";
    monk1_tree_pruned = REP(monk1_tree, monk1_tree, prune_set1 ,acc1, path); clc;
    monk2_tree_pruned = REP(monk2_tree, monk2_tree, prune_set2 ,acc2, path); clc;
    monk3_tree_pruned = REP(monk3_tree, monk3_tree, prune_set3 ,acc3, path); clc;


%     monk2_results = nan(432,1);
%     monk3_results = nan(432,1);
%     dist(validation_size);
    if isequal(monk1_tree_pruned, monk1_tree)
        disp('could not make any pruning on  monk1_tree');
        fprintf("Unpruned tree accuracy %0.10f\n", acc1);
    else
        disp("monk1_tree is pruned"); 
        monk1_results = nan(432,1);
        for I = 1:432
            monk1_results(I,1) = ID3_classify(monk1_tree_pruned, monk1_test(I,:));
        end
        acc1_prune = sum(monk1_results(:,1) == monk1_test(:,end)) / 432;
        fprintf("Pruned tree accuracy %0.10f   |   Unpruned tree accuracy %0.10f\n",acc1_prune,acc1);
        accuracies1(S) = acc1_prune;
    end
    
    

    if isequal(monk2_tree_pruned, monk2_tree)
        disp("could not make any pruning on  monk2_tree");
        fprintf("Unpruned tree accuracy %0.10f\n", acc2);
    else
        disp("monk2_tree is pruned");
        monk2_results = nan(432,1);
        for I = 1:432
            monk2_results(I,1) = ID3_classify(monk2_tree_pruned, monk2_test(I,:));   
        end
        acc2_prune = sum(monk2_results(:,1) == monk2_test(:,end)) / 432;
        fprintf("Pruned tree accuracy %0.10f   |   Unpruned tree accuracy %0.10f\n",acc2_prune,acc2);
        accuracies2(S) = acc2_prune;
    end
    



    if isequal(monk3_tree_pruned, monk3_tree)
        disp("could not make any pruning on  monk3_tree");
        fprintf("Unpruned tree accuracy %0.10f\n", acc3);
    else
        disp("monk3_tree is pruned");
            monk3_results = nan(432,1);
        for I = 1:432
            monk3_results(I,1) = ID3_classify(monk3_tree_pruned, monk3_test(I,:));   
        end
        acc3_prune = sum(monk3_results(:,1) == monk3_test(:,end)) / 432;
        fprintf("Pruned tree accuracy %0.10f   |   Unpruned tree accuracy %0.10f\n",acc3_prune,acc3);
        accuracies3(S) = acc3_prune;
    end
    
    S = S+1;
end

% clc;
figure
plot(accuracies1);
figure
plot(accuracies2);
figure
plot(accuracies3);