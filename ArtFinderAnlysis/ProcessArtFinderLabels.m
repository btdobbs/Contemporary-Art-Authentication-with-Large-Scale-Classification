class_count = 2368;
index = 1;
experiment_count = int16(class_count/100+1);
AllLabels = cell(class_count,experiment_count);
while class_count >= 100
    data_path = "/Users/btd/Library/Mobile Documents/com~apple~CloudDocs/Todd/PhD/Papers/Paper 3/ArtFinder/AllImageNetTransLearn/"; %AllImageNetTransLearn/
    labels = load(strcat(data_path,"labels_",string(class_count),".mat")).labels;
    AllLabels(1:class_count,index) = labels;
    if mod(class_count,100) == 0
        class_count = class_count - 100;
    else
        class_count = class_count - mod(class_count,100);
    end
    index = index +1;
end