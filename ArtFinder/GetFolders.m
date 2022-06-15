function [outputFolders] = GetFolders(filePath,fileCountThreshold)
    imds = imageDatastore(filePath,'IncludeSubfolders',true,'LabelSource','foldernames');
    fileCounts = countEachLabel(imds);
    thresholdFolderIndicators = fileCounts.Count >= fileCountThreshold;
    outputFolders = string(fileCounts(thresholdFolderIndicators,1).(1));
end