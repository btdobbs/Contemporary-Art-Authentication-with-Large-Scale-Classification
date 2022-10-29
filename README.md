# Steps for Experiment Reproduction
## Data
Run the code from the artfinder C# project to download art assets for MATLAB.  The DB data file is located in the artfinder folder and is compressed in sql format.  Any files image files retrieved using the data file must be removed after experimentation is complete.
## Experiment
Run AnnealingResNet.m from the ArtFinder C# project.  The transfer learning data file is too large for github so please contact me for net_imagenet_resnet_101.mat file.  You will also need to update the imageBaseFolder,  netFile, and netFolder values before running.
## Measures
After the MATLAB experiments are complete, run ProcessArtFinderResults.m from the ArtFinderAnlysis folder to generate the metrics.  You will need to change the data_path variable to the folder with the output experiment files.
## Cleanup
Please don't forget to remove ArtFinder image files after experiment is complete.
