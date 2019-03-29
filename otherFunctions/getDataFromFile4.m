function [x, y, z] = getDataFromFile4(filename)


fid = fopen(filename,'r','b');

row = fscanf(fid,'%s\n',8);

formatSpec = '%f, %f, %f';
sizeA = [3 Inf];

A = fscanf(fid,formatSpec,sizeA);

x = A(1,:);
y = A(2,:);
z = A(3,:);
fclose(fid);