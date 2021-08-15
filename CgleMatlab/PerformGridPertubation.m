function grid = PerformGridPertubation(functions, grid, pertubationCoefficient)
    % function constatins = PerformGridPertubation(functions, grid, pertubationCoefficient)
    %
    % Author1: Yoan Yomba (yoyomba@microsoft.com)
    % Date:    Winter 2021
    % Application:  Cubic Quintic Ginzburg Landau
    %
    % Function   : PerformGridPertubation
    %
    % Description: Perturbs grid and generates ground truth
    %
    % Parameters : grid - a struct comprised of solution specific of grid
    % parameters
    %              functions - a struct comprised of function parameters
    %              pertubationCoefficient - a double used to observe the amount of
    %              noise to apply to the wave
    %
    % Return     : a grid struct with populated ground truth and pertubated wave
    %
    % Examples of Usage:
    %
    %
    % >> metadata = {};
    % >> metadata.WaveType = "Bright-Bright";
    % >> metadata.CaseType = 2;
    % >> metadata.Version = 2;
    % >> functions = ComputeFunctionsAndRelatedFields(metadata)
    %
    % >> interval = {};
    % >> interval.StartTime = 0;
    % >> interval.EndTime = 3;
    % >> interval.StartPosition = -8;
    % >> interval.EndPosition = 8;
    % >> multiplier = 31;
    % >> grid = ComputeGrid(interval,multiplier)
    %
    % >> pertubationCoefficient = 0.10;
    % >> grid = PerformGridPertubation(functions, grid, pertubationCoefficient)
    %
    % grid =
    %   struct with fields:
    %
    %                 Nx: 17
    %                 Nt: 4
    %                 Dx: 1
    %                 Dt: 1
    %                  X: [-8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8]
    %                  T: [0 1 2 3]
    %                  U: [17�4 double]
    %     PerturbedGridA: [17�4 double]
    %     PerturbedGridB: [17�4 double]
    %       GroundTruthA: [17�4 double]
    %       GroundTruthB: [17�4 double]

    if functions.Metadata.Version == 2
        grid.WaveType = functions.Metadata.WaveType;

        for i = 1:length(grid.X)

            for j = 1:length(grid.T)
                % compute the pertued wave
                xPoint = grid.X(1, i);
                yPoint = grid.T(1, j);

                if (xPoint == 0 && yPoint > 0) || (xPoint > 0 && yPoint == 0) || (xPoint == 0 && yPoint == 0)
                    % apply white noise to perturbed wave
                    grid.PerturbedGridA(j, i) = functions.A(xPoint, yPoint, functions.Constraints) * ...
                        (1 + (pertubationCoefficient * rand(1)));
                    grid.PerturbedGridB(j, i) = functions.B(xPoint, yPoint, functions.Constraints) * ...
                        (1 + (pertubationCoefficient * rand(1)));
                    grid.InitialA(j, i) = grid.PerturbedGridA(j, i);
                    grid.InitialB(j, i) = grid.PerturbedGridB(j, i);
                else
                    grid.PerturbedGridA(j, i) = functions.A(xPoint, yPoint, functions.Constraints);
                    grid.PerturbedGridB(j, i) = functions.B(xPoint, yPoint, functions.Constraints);
                end

                % compute ground truth
                grid.GroundTruthA(j, i) = functions.A(xPoint, yPoint, functions.Constraints);
                grid.GroundTruthB(j, i) = functions.B(xPoint, yPoint, functions.Constraints);
            end

        end

        %grid.PerturbedGridA = grid.PerturbedGridA; %+ grid.GroundTruthA;
        %grid.PerturbedGridB = grid.PerturbedGridB; %+ grid.GroundTruthB;
    end

end
