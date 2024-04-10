pathToSleapAnalysis = 'R:\DataBackup\RothschildLab\utku\Josh\video\labels.v002.006_Basler_acA4024-29um__24844056__20240125_130929331_1.analysis.h5';
occupancyMatrix = h5read(pathToSleapAnalysis,'/track_occupancy');
tracksMatrix = h5read(pathToSleapAnalysis,'/tracks');
instanceScores = h5read(pathToSleapAnalysis,'/instance_scores');
nodeNames = h5read(pathToSleapAnalysis,'/node_names');