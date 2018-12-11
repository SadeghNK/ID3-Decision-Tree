function [ data ] = data_read( path )

data_format = '%d %d %d %d %d %d %d %s';
file = fopen(path);
n = 0;
current_line = fgetl(file);
while ischar(current_line)
  current_line = fgetl(file);
  n = n+1;
end
frewind(file);
data = textscan(file, data_format, n,'delimiter','\n');
fclose(file);
data(8) = [];
data = cell2mat(data);
data(:,8) = data(:,1);
data(:,1:7) = data(:,2:8);
data(:,8) = [];

end

