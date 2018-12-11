function [ ent ] = ent( data )
p0 = (sum(data(:,end) == 0)) / length(data);
p1 = 1 - p0;
if p0 == 0 || p1 == 0
    ent = 0;
else
    ent = -p0 * log2(p0) -p1 * log2(p1);
end
end