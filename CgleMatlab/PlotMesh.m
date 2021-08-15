function PlotMesh(grid, isStabilityAnalysis, plotGradient)
% function grid = PlotGridResults(intervals) 
% 
% Author1: Yoan Yomba (yoyomba@microsoft.com) 
% Date:    Winter 2021 
% Application:  Cubic Quintic Ginzburg Landau
% 
% Function   : PlotGridResults 
% 
% Description: Plots grid parameters
% 
% Parameters : grid - a struct comprised of grid parameters
%
% Examples of Usage: 
%   PlotGridResults(grid);
%
    stabilitityAnalysisText = "";
    
    
    T = grid.T;
    X = grid.X;
    v = 3;
    wavetype = grid.WaveType;
    
    stabilitityAnalysisText = "  - Post Stability Analysis Result";
    ampAText = "Amplitude A(x,t) of " +  wavetype;
    ampAPerturbedText = "Amplitude A(x,t) Perturbed of " + grid.WaveType + stabilitityAnalysisText;

    ampBText = "Amplitude B(x,t) of " + grid.WaveType;
    ampBPerturbedText = "Amplitude B(x,t) Perturbed of " + grid.WaveType +stabilitityAnalysisText;
    
    if isStabilityAnalysis

        stabilitityAnalysisText = "  - Post Stability Analysis Result";
        
        subplot(2,2,1)
        mesh(X,T,abs(grid.GroundTruthA)); 
        title(ampAText);
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);
        axis on;
        hidden off;

        subplot(2,2,2)
        mesh(X,T,abs(grid.GroundTruthB));
        title(ampBText);
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);  
        axis on;
        hidden off;     
        
        subplot(2,2,3)
        if plotGradient 
           PlotGradient(X, T, (grid.PerturbedGridAA), true)
        else 
            mesh(X,T,abs(grid.PerturbedGridAA));
            hold on
            [FX,FY] = gradient(abs(grid.PerturbedGridAA));   
            quiver(X,T,FX,FY)
        end
        title(ampAPerturbedText);
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);  
        axis on;
        hidden off; 

        subplot(2,2,4)
        if plotGradient 
           PlotGradient(X, T, (grid.PerturbedGridBB), true)
        else 
            mesh(X,T,abs(grid.PerturbedGridBB));
            hold on
            [FX,FY] = gradient(abs(grid.PerturbedGridBB));   
            quiver(X,T,FX,FY)
        end
        title(ampBPerturbedText);
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);  
        axis on;
        hidden off;

    else 
        subplot(2,2,1)
        mesh(X,T,abs(grid.GroundTruthA),  'EdgeColor', 'black');
        title(ampAText);
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);
        axis on;
        hidden off;

        subplot(2,2,2)
        mesh(X,T,abs(grid.GroundTruthB), 'EdgeColor', 'black');
        title(ampBText);
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);  
        axis on;
        hidden off;

        subplot(2,2,3)
        if plotGradient 
           PlotGradient(X, T, grid.PerturbedGridAA, true)
        else 
            mesh(X,T,abs(grid.PerturbedGridAA),  'EdgeColor', 'black');
        end
        title(ampAPerturbedText);
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);  
        axis on;
        hidden off;

        subplot(2,2,4)
        if plotGradient 
           PlotGradient(X, T, (grid.PerturbedGridBB), true)
        else 
            mesh(X,T,abs(grid.PerturbedGridBB),  'EdgeColor', 'black');
        end
        title(ampBPerturbedText);
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);  
        axis on;
        hidden off;
    end  
end

function PlotGradient(x, t, amplitude , plotGradient)
    if plotGradient
        [dfdx,dfdy] = gradient(amplitude);
        mesh(x, t, abs(amplitude), abs(sqrt(dfdx.^2 + dfdy.^2)), 'EdgeColor', 'black');
    end
end