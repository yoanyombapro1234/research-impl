function PlotGridSurfaceResults(grid, isStabilityAnalysis)
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

    v = [30, 45];

    if isStabilityAnalysis

        stabilitityAnalysisText = "  - Post Stability Analysis Result";

        subplot(3, 2, 1)
        s1 = surf(X, T, abs(grid.GroundTruthA), 'FaceAlpha', '0.1', 'edgecolor', 'k');
        s1.EdgeColor = 'none';
        axis tight;
        title("Amplitude A(x,t)");
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);
        axis on;
        hidden off;

        subplot(3, 2, 2)
        s1 = surf(X, T, abs(grid.GroundTruthB), 'FaceAlpha', '0.1', 'edgecolor', 'k');
        s1.EdgeColor = 'none';
        title("Amplitude B(x,t)");
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);
        axis on;
        hidden off;

        subplot(3, 2, 5)
        s1 = surf(X, T, abs(grid.PerturbedGridA), 'FaceAlpha', '0.1', 'edgecolor', 'k');
        s1.EdgeColor = 'none';
        title("Amplitude Noise A(x,t) Perturbed" + stabilitityAnalysisText);
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);
        axis on;
        hidden off;

        subplot(3, 2, 6)
        s1 = surf(X, T, abs(grid.PerturbedGridB), 'FaceAlpha', '0.1', 'edgecolor', 'k');
        s1.EdgeColor = 'none';
        title("Amplitude Noise B(x,t) Perturbed" + stabilitityAnalysisText);
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);
        axis on;
        hidden off;

        subplot(3, 2, 3)
        s1 = surf(X, T, abs(grid.InitialA), 'FaceAlpha', '0.1', 'edgecolor', 'k');
        lighting gouraud % preferred method for lighting curved surfaces
        title("Initial Condition - Amplitude Noise A(x,t) Bright-Bright");
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);
        axis on;
        hidden off;

        subplot(3, 2, 4)
        s1 = surf(X, T, abs(grid.InitialB), 'FaceAlpha', '0.1', 'edgecolor', 'k');
        lighting gouraud % preferred method for lighting curved surfaces
        title("Initial Condition - Amplitude Noise B(x,t) Bright-Bright");
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);
        axis on;
        hidden off;
    else
        subplot(2, 2, 1)
        s1 = surf(X, T, abs(grid.GroundTruthA), 'FaceAlpha', '0.1', 'edgecolor', 'k');
        s1.EdgeColor = 'none';
        axis tight;
        title("Amplitude A(x,t)");
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);
        axis on;
        hidden off;

        subplot(2, 2, 2)
        s1 = surf(X, T, abs(grid.GroundTruthB), 'FaceAlpha', '0.1', 'edgecolor', 'k');
        s1.EdgeColor = 'none';
        title("Amplitude B(x,t)");
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);
        axis on;
        hidden off;

        subplot(2, 2, 3)
        s1 = surf(X, T, abs(grid.PerturbedGridA), 'FaceAlpha', '0.1', 'edgecolor', 'k');
        s1.EdgeColor = 'none';
        title("Amplitude Noise A(x,t) Perturbed" + stabilitityAnalysisText);
        xlabel('space'); ylabel('time'); zlabel("|A|^2");
        view(v);
        axis on;
        hidden off;

        subplot(2, 2, 4)
        s1 = surf(X, T, abs(grid.PerturbedGridB), 'FaceAlpha', '0.1', 'edgecolor', 'k');
        s1.EdgeColor = 'none';
        title("Amplitude Noise B(x,t) Perturbed" + stabilitityAnalysisText);
        xlabel('space'); ylabel('time'); zlabel("|B|^2");
        view(v);
        axis on;
        hidden off;
    end

end
