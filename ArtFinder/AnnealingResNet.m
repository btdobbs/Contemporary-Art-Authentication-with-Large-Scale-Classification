imageBaseFolder = "/Users/btd/artfinder/";
netFile = "/Users/btd/Documents/MATLAB/ArtFinder/net_imagenet_resnet_101.mat";
netFolder = "/Users/btd/Documents/MATLAB/ArtFinder/";
imageCountThreshold = 10; %1000;
classAnnealingCount = 100; %2;
imageFolders = GetFolders(imageBaseFolder, imageCountThreshold);
imageFolderBatchCountRemainder = mod(size(imageFolders, 1), classAnnealingCount);
imageFolderBatchCount = floor(size(imageFolders, 1)/classAnnealingCount);
if imageFolderBatchCountRemainder > 0
    imageFolderBatchCount = imageFolderBatchCount + 1;
    batchFolderCount = imageFolderBatchCountRemainder;
else
    batchFolderCount = classAnnealingCount;
end
batchFolderCounts = zeros(1, imageFolderBatchCount);
for i = 1:imageFolderBatchCount
    imds = GetImageDatastore(imageBaseFolder, imageFolders);
    batchFolderCounts(i) = size(imds.Folders, 1);
    worstPerformingIndiciesFile = strcat("worstPerformingIndicies_",string(batchFolderCounts(i)),".mat");
    if isfile(worstPerformingIndiciesFile)
         worstPerformingIndicies = load(worstPerformingIndiciesFile).worstPerformingIndicies;
    else
        dagNetwork = load(netFile).net;
        inputLayerGraph = CreateLgraphUsingConnections(dagNetwork.Layers, dagNetwork.Connections);
        confusionMatrix = DoResNet(inputLayerGraph, imds);
        worstPerformingIndicies = GetWorstPerformingIndicies(confusionMatrix, batchFolderCount);
        save(worstPerformingIndiciesFile, "worstPerformingIndicies");
    end
    imageFolders(worstPerformingIndicies') = [];
    netFile = strcat(netFolder, "net_", string(batchFolderCounts(i)),".mat");
    batchFolderCount = classAnnealingCount;
end