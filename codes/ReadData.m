function [lines,Levels,Modes,nums,Th,sim,appro, ranges] = ReadData(filename)
    
    %This function is used to read and organize requirements

    fid = fopen(filename);
    cells = textscan(fid,'%s %s %d %s %s %s %s','Delimiter',',');
    fclose(fid);
    
    lines = size(cells{1},1);
    
    Levels = cells{1};
    Modes = cells{2};
    nums = cells{3};
    Th = cells{4};
    sim = cells{5};
    appro = cells{6};
    ranges = cells{7};
    
    C = {};%convert String type range into Mat
    for i=1:length(ranges)
       range = ranges{i};
       range = string(split(range,':'));
       range = double(range);
       range = range(1):range(2):range(3);
       C{i} = range;
    end
    ranges = C;
end

