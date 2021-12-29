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
         ga = grid.GroundTruthA(:, 2:end-1);
         ga = ga(2:end-1, :);
         
         gb = grid.GroundTruthB(:, 2:end-1);
         gb = gb(2:end-1, :);
         
         d = grid.PerturbedGridAA(:, 2:end-1);
         d = d(2:end-1, :);
         
         e = grid.PerturbedGridBB(:, 2:end-1);
         e = e(2:end-1, :);

         x = grid.X(2:end-1);
         t = grid.T(2:end-1);
         x = grid.X(2:end-1);
     
        subplot(2,3,1)
        mesh(X,T,abs(grid.GroundTruthA), 'MeshStyle', 'column', 'LineWidth', 0.2); 
        title(ampAText);
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);
        axis on;
        hidden off;

        subplot(2,3,2)
        mesh(X,T,abs(grid.GroundTruthB), 'MeshStyle', 'row', 'LineWidth', 1, 'edgecolor', 'k');
        title(ampBText);
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);  
        axis on;
        hidden off;     
        
        subplot(2,3,3)
        if plotGradient 
           PlotGradient(x, t, d, true)
        else 
            mesh(x,t,abs(d),'MeshStyle', 'row', 'LineWidth', 1, 'edgecolor', 'k');
            %hold on
            %[FX,FY] = gradient(abs(d));   
            %quiver(x,t,FX,FY)
        end
        title(ampAPerturbedText);
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);  
        axis on;
        hidden off; 

        subplot(2,3,4)
        if plotGradient 
           PlotGradient(t, x, e, true)
        else 
            mesh(x,t,abs(e), 'MeshStyle', 'column', 'LineWidth', 0.2);
            %hold on
            %[FX,FY] = gradient(abs(e));   
            %quiver(x,t,FX,FY)
        end
        title(ampBPerturbedText);
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);  
        axis on;
        hidden off;

        subplot(2,3,5)
        mesh(x,t,abs(e)-abs(gb));
        title("absolute amplitude difference between ground truth B and perturbed B");
        
        subplot(2,3,6)
        mesh(x, t,abs(d)-abs(ga));
        title("absolute amplitude difference between ground truth A and perturbed A");
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