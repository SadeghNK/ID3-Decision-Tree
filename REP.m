function [ pruned_tree ] = REP( old_tree ,tree, prune_set, current_accu , path )

major = nan(4,1);
pad = "";
% cur_tree = tree;

if(tree.tclass == -1)
    if ~isempty(tree.subnode1)
        major(1) = tree.subnode1.tclass;
        if tree.subnode1.count_child_node ~= 0
            path(tree.level + 2) = ".subnode1";
            leaf1 = REP(old_tree, tree.subnode1, prune_set, current_accu, path);
            tree.subnode1 = leaf1;
            path(tree.level + 2) = [];
        end
    end
    if ~isempty(tree.subnode2)
        major(2) = tree.subnode2.tclass;
        if tree.subnode2.count_child_node ~= 0
            path(tree.level + 2) = ".subnode2";
            leaf2 = REP(old_tree, tree.subnode2, prune_set, current_accu, path);
            tree.subnode2 = leaf2;
            path(tree.level + 2) = [];
        end
    end
    if ~isempty(tree.subnode3)
        major(3) = tree.subnode3.tclass;
        if tree.subnode3.count_child_node ~= 0
            path(tree.level + 2) = ".subnode3";
            leaf3 = REP(old_tree, tree.subnode3, prune_set, current_accu, path);
            tree.subnode3 = leaf3;
            path(tree.level + 2) = [];
        end
    end
    
    if ~isempty(tree.subnode4)
        major(4) = tree.subnode4.tclass;
        if tree.subnode4.count_child_node ~= 0
            path(tree.level + 2) = ".subnode4";
            leaf4 = REP(old_tree, tree.subnode4, prune_set, current_accu, path);
            tree.subnode4 = leaf4;
            path(tree.level + 2) = [];
        end
    end
end

% major(isnan(major)) = [];

if (sum(major == 1) > sum(major == 0))
    major_vote = 1;
elseif (sum(major == 1) < sum(major == 0))
    major_vote = 0;
else
    major_vote = datasample(major, 1);
end
temp1 = tree;
% temp2 = old_tree;
tree.tclass = major_vote;
for I=1:(tree.level+1) 
    pad = pad + path(I);
end

pad = pad + "=tree";
eval(pad);

results = nan(length(prune_set), 1);

for I = 1:length(prune_set)
    results(I,1) = ID3_classify(old_tree, prune_set(I,:));
end

new_accu = sum(results(:,1) == prune_set(:,end)) / length(prune_set);
if new_accu >= current_accu
    pruned_tree = tree;
    return
else
%   old_tree = temp2;
    tree = temp1;
    pruned_tree = tree;
    return
end

