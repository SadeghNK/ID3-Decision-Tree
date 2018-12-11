function [node] = ID3_buildtree(dataset, level)

%structure of node
%	node.subnode() : subnode for each of splitted values
%   node.split_attribute : selected splitting attribute on current node
%   node.split_vars : set of unique values of the splitted attribute
%   node.info_gain : value of information gain
%   node.count_child_node : count of elements in the child node
%   node.level : level -- start building tree by setting this to 0
%   node.tclass : target class

%create a blank node 
clear node;

[~, ncols] = size(dataset);
target_class = ncols;
classes = [1; 0];

%stop if we have reached the maximum level
if(level >= (ncols - 1))
    node.subnode1 = [];
    node.subnode2 = [];
    node.subnode3 = [];
    node.subnode4 = [];
    node.split_attribute = 0;
    node.split_vars = [];
    node.info_gain = 0;
    node.count_child_node = 0;
    node.level = 0;

    if( sum(dataset(:,target_class) == 1) > sum(dataset(:,target_class) == 0) )
        node.tclass = 1;
    elseif( sum(dataset(:,target_class) == 1) < sum(dataset(:,target_class) == 0) )
        node.tclass = 0;
    else
        node.tclass = datasample(classes,1,'Replace',true);
    end
    
    return;
end

%calculate information gain for this current dataset
g = gain(dataset);

[max_info_gain, split_attr] = max(g);

%if max gain gives zero or negative result, stop growing
if (max_info_gain <= 0)
    node.subnode1 = [];
    node.subnode2 = [];
    node.subnode3 = [];
    node.subnode4 = [];
    node.split_attribute = 0;
    node.split_vars = [];
    node.info_gain = 0;
    node.count_child_node = 0;
    node.level = 0;

    if(sum(dataset(:,target_class) == 1) > sum(dataset(:,target_class) == 0)) 
        node.tclass = 1; 
    elseif(sum(dataset(:,target_class) == 1) < sum(dataset(:,target_class) == 0))
        node.tclass = 0;
    else
        node.tclass = datasample(classes,1,'Replace',true);
    end 
    return;
end 


%now, set up node
node.subnode1 = [];
node.subnode2 = [];
node.subnode3 = [];
node.subnode4 = [];
node.split_attribute = split_attr;
node.split_vars = unique(dataset(:, split_attr));
node.info_gain = max_info_gain;
unique_vals = unique(dataset(:, split_attr));
node.count_child_node = length(unique_vals);
node.level = level;
node.tclass = -1;
% node.tclass is not evaluated here because it has children


for i = 1 : node.count_child_node

    clear new_node;
    
%create a new dataset per each subnode
%split it by {values} in split_attr 
    new_dataset = subset( dataset , split_attr , unique_vals(i));

%create empty leaf if new_dataset is blank 
    if(isempty(new_dataset)) 
        new_node.subnode1 = [];
        new_node.subnode2 = [];
        new_node.subnode3 = [];
        new_node.subnode4 = [];
        new_node.split_attribute = 0;
        new_node.split_vars = [];
        new_node.info_gain = 0;
        new_node.count_child_node = 0;
        new_node.level = 0;
        new_node.tclass = -1;
        
    else
        %recursion
        new_node = ID3_buildtree(new_dataset, level+1);
    end

    if(unique_vals(i) == 1)
        node.subnode1 = new_node;
    elseif(unique_vals(i) == 2)
        node.subnode2 = new_node;
    elseif(unique_vals(i) == 3)
        node.subnode3 = new_node;
    elseif(unique_vals(i) == 4)
        node.subnode4 = new_node;
    end

end

%special cases, which are not seen in entire train set
%just classify them using their parent's major vote in classes
if ~isequal(unique_vals,[1;2;3;4]) && ~isequal(unique_vals,[1;2;3]) && ~isequal(unique_vals,[1;2])
    
    major_vote = mode(new_dataset(:,end));
    
    if isempty(node.subnode1)
        node.subnode1.subnode1 = [];
        node.subnode1.subnode2 = [];
        node.subnode1.subnode3 = [];
        node.subnode1.subnode4 = [];
        node.subnode1.split_attribute = 0;
        node.subnode1.tclass = major_vote;
        node.subnode1.count_child_node = 0;
    end
    if isempty(node.subnode2)
         node.subnode2.subnode1 = [];
         node.subnode2.subnode2 = [];
         node.subnode2.subnode3 = [];
         node.subnode2.subnode4 = [];
         node.subnode2.split_attribute = 0;
        node.subnode2.tclass = major_vote;
        node.subnode2.count_child_node = 0;
    end
    if isempty(node.subnode3)
        node.subnode3.subnode1 = [];
        node.subnode3.subnode2 = [];
        node.subnode3.subnode3 = [];
        node.subnode3.subnode4 = [];
        node.subnode3.split_attribute = 0;
        node.subnode3.tclass = major_vote;
        node.subnode3.count_child_node = 0;
    end
    if isempty(node.subnode4)
        node.subnode4.subnode1 = [];
        node.subnode4.subnode2 = [];
        node.subnode4.subnode3 = [];
        node.subnode4.subnode4 = [];
        node.subnode1.split_attribute = 0;
        node.subnode4.tclass = major_vote;
        node.subnode4.count_child_node = 0;
    end
    
    
end

%%
if node.split_attribute == 1 || node.split_attribute == 2 || node.split_attribute == 4
    major_vote = mode(new_dataset(:,end));
    if isempty(node.subnode1)
        node.subnode1.subnode1 = [];
        node.subnode1.subnode2 = [];
        node.subnode1.subnode3 = [];
        node.subnode1.subnode4 = [];
        node.subnode1.split_attribute = 0;
        node.subnode1.tclass = major_vote;
        node.subnode1.count_child_node = 0;
    end
    if isempty(node.subnode2)
         node.subnode2.subnode1 = [];
         node.subnode2.subnode2 = [];
         node.subnode2.subnode3 = [];
         node.subnode2.subnode4 = [];
         node.subnode2.split_attribute = 0;
        node.subnode2.tclass = major_vote;
        node.subnode2.count_child_node = 0;
    end
    if isempty(node.subnode3)
        node.subnode3.subnode1 = [];
        node.subnode3.subnode2 = [];
        node.subnode3.subnode3 = [];
        node.subnode3.subnode4 = [];
        node.subnode3.split_attribute = 0;
        node.subnode3.tclass = major_vote;
        node.subnode3.count_child_node = 0;
    end
end

if node.split_attribute == 3 || node.split_attribute == 6
    major_vote = mode(new_dataset(:,end));
    if isempty(node.subnode1)
        node.subnode1.subnode1 = [];
        node.subnode1.subnode2 = [];
        node.subnode1.subnode3 = [];
        node.subnode1.subnode4 = [];
        node.subnode1.split_attribute = 0;
        node.subnode1.tclass = major_vote;
        node.subnode1.count_child_node = 0;
    end
    if isempty(node.subnode2)
         node.subnode2.subnode1 = [];
         node.subnode2.subnode2 = [];
         node.subnode2.subnode3 = [];
         node.subnode2.subnode4 = [];
         node.subnode2.split_attribute = 0;
        node.subnode2.tclass = major_vote;
        node.subnode2.count_child_node = 0;
    end
end
   
if node.split_attribute == 5
    major_vote = mode(new_dataset(:,end));
    
    if isempty(node.subnode1)
        node.subnode1.subnode1 = [];
        node.subnode1.subnode2 = [];
        node.subnode1.subnode3 = [];
        node.subnode1.subnode4 = [];
        node.subnode1.split_attribute = 0;
        node.subnode1.tclass = major_vote;
        node.subnode1.count_child_node = 0;
    end
    if isempty(node.subnode2)
         node.subnode2.subnode1 = [];
         node.subnode2.subnode2 = [];
         node.subnode2.subnode3 = [];
         node.subnode2.subnode4 = [];
         node.subnode2.split_attribute = 0;
        node.subnode2.tclass = major_vote;
        node.subnode2.count_child_node = 0;
    end
    if isempty(node.subnode3)
        node.subnode3.subnode1 = [];
        node.subnode3.subnode2 = [];
        node.subnode3.subnode3 = [];
        node.subnode3.subnode4 = [];
        node.subnode3.split_attribute = 0;
        node.subnode3.tclass = major_vote;
        node.subnode3.count_child_node = 0;
    end
    if isempty(node.subnode4)
        node.subnode4.subnode1 = [];
        node.subnode4.subnode2 = [];
        node.subnode4.subnode3 = [];
        node.subnode4.subnode4 = [];
        node.subnode1.split_attribute = 0;
        node.subnode4.tclass = major_vote;
        node.subnode4.count_child_node = 0;
    end
end
end