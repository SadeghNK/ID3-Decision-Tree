function [ classification ] = ID3_classify( tree , sample )

if tree.tclass == 1
    classification = 1;
    return

elseif tree.tclass == 0
    classification = 0;
    return

%recursion if tclass == -1
else
    split_attr = tree.split_attribute;
    if split_attr == 0
        classification = -1;
    else
        if sample(split_attr) == 1
            classification = ID3_classify(tree.subnode1, sample); 
        elseif sample(split_attr) == 2
            classification = ID3_classify(tree.subnode2, sample);
        elseif sample(split_attr) == 3
            classification = ID3_classify(tree.subnode3, sample);
        elseif sample(split_attr) == 4
            classification = ID3_classify(tree.subnode4, sample);
        end
    end
end

return

end