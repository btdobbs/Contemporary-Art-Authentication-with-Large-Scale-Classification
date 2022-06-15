class_count = 2368;
artist_indicies = [39 38 36 35 33 30 28 26 24 22 22 22 21 19 15 14 13 12 9 7 6 4 3 1];
index = 1;
ExperimentCount = int16(class_count/100+1);
AllMetrics = zeros(ExperimentCount,13,"double");
while class_count >= 100
    data_path = "/Users/btd/Library/Mobile Documents/com~apple~CloudDocs/Todd/PhD/Papers/Paper 3/ArtFinder/AllImageNetTransLearn/";
    confusion_matrix = load(strcat(data_path,"cm_",string(class_count),".mat")).ConfusionMatrix;
    artist_index = artist_indicies(index);
    Metrics = GetMetricsArtist(confusion_matrix, class_count, artist_index);
    AllMetrics(index,:) = Metrics';
    if mod(class_count,100) == 0
        class_count = class_count - 100;
    else
        class_count = class_count - mod(class_count,100);
    end
    index = index +1;
end