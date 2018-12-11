function [ subset ] = subset( data , attr_num , value )
subset = data(:, attr_num) == value;
subset = data(subset, :);
end

