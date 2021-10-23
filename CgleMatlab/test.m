% TODO
% 1). Bright-Bright, Dark-Dark, Front-Front (case 2): Play with value of L
% 2). Look into folding behavior 
% 3). Variety of graphs capturing rate of change in amplitude over time
clc; clear all; close all;
darkdark.WaveType = "Dark-Dark";
darkdark.Version = 2;

brightbright.WaveType = "Bright-Bright";
brightbright.Version = 2;

frontfront.WaveType = "Front-Front";
frontfront.Version = 2;

metas = [darkdark, brightbright, frontfront];

CaseTypes = 2;
numPoints = 50;
pertubationCoefficient = 0.05;

% define plotting configurations
isStabilityAnalysisPlot = true;
isShadingInterpEnabled =  true;
isLightGourandEnabled = true;
isMaterialDullEnabled = false;
isPlotMeshGradientEnabled = true;

destination = "C:/Users/yoanyomba/Desktop/research-ccgl/CGL/images";
ext = "jpg";

for j = 1:1%length(metas) 
  for i = 2 %1:CaseTypes
     metadata = metas(j);
     metadata.CaseType = i;
     % obtain functions and constraints of interest
     functions = ComputeFunctionsAndRelatedFields(metadata);
     % define grid and associated parameteres
     grid = ComputeGrid(functions.Constraints,numPoints);
     % perform initial pertubation
     grid = PerformGridPertubation(functions, grid, pertubationCoefficient);
     % perform stability analysis
     grid = PerformNovelStabilityAnalysis(functions, grid);
     
     fileName = grid.WaveType + "-CaseType-" + num2str(metadata.CaseType) ...
            + "-isShadingInterpEnabled-" + string(isShadingInterpEnabled) ...
            + "-isLightGourandEnabled-" + string(isLightGourandEnabled) ...
            + "-isMaterialDullEnabled-" + string(isMaterialDullEnabled);
     
     fileNameMesh = fileName + "-isPlotMeshGradientEnabled-" + string(isPlotMeshGradientEnabled);

     % outSurfaceFile = fullfile(destination, sprintf('%s',fileName));  
     % outMeshFile = fullfile(destination, sprintf('%s',fileNameMesh));   
     
     PlotMesh(grid, false, isPlotMeshGradientEnabled);
     %saveas(gcf, sprintf('%s',fileNameMesh), 'jpeg');
     
     % generate plots
     % PlotSurface(grid, isStabilityAnalysisPlot, isShadingInterpEnabled, isLightGourandEnabled, isMaterialDullEnabled);
     % saveas(gcf, sprintf('%s',fileName), 'jpeg');

  end
end

function Rotate()
    % Single rotation of azimuth

    for i = -37.5:5:322.5
        view(i, 30); %update view
        pause(0.1); %makes the rotation easier to see by waiting a fraction of a second
    end

    % Single rotation of elevation

    for i = -330:5:30
        view(i, i); %update view
        pause(0.1);
    end
end


