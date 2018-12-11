function [ gain ] = gain( data )

gain = zeros(size(dataset, 2)-1 ,1);
for J = 1:(size(data, 2) - 1)
    values = unique(data(:, J));

    values_subsets = cell(length(values), 1);
    for I=1:length(values)
        values_subsets{I} = subset(data, J, values(I));
    end

    subs_ents = 0;
    for I=1:length(values_subsets)
        subs_ents = subs_ents + ((length(values_subsets{I}) / length(data)) * ent(values_subsets{I}));
    end

    gain(J) = ent(data) - subs_ents;
end
end

