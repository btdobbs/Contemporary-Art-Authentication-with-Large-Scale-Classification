function [outputImageDatastore] = GetImageDatastore(filePath,inputImageFolders)
    imageFolders = strcat(filePath, inputImageFolders);
    outputImageDatastore = imageDatastore(imageFolders,'IncludeSubfolders',false,'LabelSource','foldernames');
end