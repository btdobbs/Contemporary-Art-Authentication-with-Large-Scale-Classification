# Steps for Experiment Reproduction
## Data
Run the code from the artfinder C# project to download art assets for MATLAB.  The DB data file is too large for github so please contact me for database.  These files must be removed after the MATLAB models are created.
## Experiment
Run AnnealingResNet.m from the ArtFinder C# project.  The transfer learning data file is too large for github so please contact me for net_imagenet_resnet_101.mat file.  You will also need to update the imageBaseFolder,  netFile, and netFolder values before running.
## Measures
After the MATLAB experiments are complete, run ProcessArtFinderResults.m from the ArtFinderAnlysis folder to generate the metrics.  You will need to change the data_path variable to the folder with the output experiment files.
## Cleanup
Please don't forget to remove ArtFinder image files after experiment is complete.
