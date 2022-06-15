class_count = 2368;
index = 1;
ExperimentCount = int16(class_count/100+1);
AllMetrics = zeros(ExperimentCount,1,"double");
while class_count >= 100
    data_path = "/Users/btd/Library/Mobile Documents/com~apple~CloudDocs/Todd/PhD/Papers/Paper 3/ArtFinder/AllImageNetTransLearn/";
    confusion_matrix = load(strcat(data_path,"cm_",string(class_count),".mat")).ConfusionMatrix;
    total_row = sum(confusion_matrix,2);
    total_row_avg = sum(total_row)/class_count;
    AllMetrics(index,1) = total_row_avg;
    if mod(class_count,100) == 0
        class_count = class_count - 100;
    else
        class_count = class_count - mod(class_count,100);
    end
    index = index +1;
end