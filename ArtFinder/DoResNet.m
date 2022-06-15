function ConfusionMatrix = DoResNet(inputLayerGraph, inputImageDataStore)
    tic
    
    classCount = length(unique(inputImageDataStore.Labels));
    disp(strcat("processing class count = ", string(classCount)));
    [imdsTrain, imdsValidation, imdsTest] = splitEachLabel(inputImageDataStore,0.7,.1);

    imageAugmenter = imageDataAugmenter(...
        "RandRotation",[-90 90],...
        "RandScale",[1 2],...
        "RandXReflection",true);
    augimdsTrain = augmentedImageDatastore([224 224 3],imdsTrain,"DataAugmentation",imageAugmenter,"ColorPreprocessing","gray2rgb");
    augimdsValidation = augmentedImageDatastore([224 224 3],imdsValidation,"ColorPreprocessing","gray2rgb");

    opts = trainingOptions("sgdm",...
        "ExecutionEnvironment","parallel",...
        "InitialLearnRate",0.01,...
        "Shuffle","every-epoch",...
        "Plots","training-progress",...
        "ValidationData",augimdsValidation);

    fcLayer = (fullyConnectedLayer(classCount,"Name","fc"));
    inputLayerGraph = replaceLayer(inputLayerGraph,'fc',fcLayer);
    classoutputLayer = (classificationLayer("Name","classoutput"));
    inputLayerGraph = replaceLayer(inputLayerGraph,'classoutput',classoutputLayer);

    [net, info] = trainNetwork(augimdsTrain,inputLayerGraph,opts);

    save(strcat("info_",string(classCount),".mat"), "info");
    save(strcat("net_",string(classCount),".mat"), "net");

    augimdsTest = augmentedImageDatastore([224 224 3],imdsTest,"ColorPreprocessing","gray2rgb");

    YPred = classify(net,augimdsTest);

    labels = categories(imdsTest.Labels);

    ConfusionMatrix = confusionmat(imdsTest.Labels,YPred);

    save(strcat("labels_",string(classCount),".mat"), "labels");
    save(strcat("cm_",string(classCount),".mat"), "ConfusionMatrix");

    toc
end

