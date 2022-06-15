class_count = 2368;
index = 1;
ExperimentCount = int16(class_count/100+1);
AllMetrics = zeros(ExperimentCount,14,"double");
while class_count >= 100
    data_path = "/Users/btd/Library/Mobile Documents/com~apple~CloudDocs/Todd/PhD/Papers/Paper 3/ArtFinder/AllImageNetTransLearn/";
    info = load(strcat(data_path,"info_",string(class_count),".mat")).info;
    FinalValidationAccuracy = info.FinalValidationAccuracy;
    confusion_matrix = load(strcat(data_path,"cm_",string(class_count),".mat")).ConfusionMatrix;
    Metrics = GetMetrics(confusion_matrix, class_count);
    AllMetrics(index,:) = Metrics';
    %AllMetrics(index,14) = FinalValidationAccuracy;
    if mod(class_count,100) == 0
        class_count = class_count - 100;
    else
        class_count = class_count - mod(class_count,100);
    end
    index = index +1;
end