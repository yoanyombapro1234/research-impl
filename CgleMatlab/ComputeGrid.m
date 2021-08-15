function grid = ComputeGrid(intervals, numberOfPoints)
    % function grid = ComputeGrid(intervals)
    %
    % Author1: Yoan Yomba (yoyomba@microsoft.com)
    % Date:    Winter 2021
    % Application:  Cubic Quintic Ginzburg Landau
    %
    % Function   : ComputeGrid
    %
    % Description: Computes the grid based on defined intervals, and a multiplier
    % which amplifies the number of points in a defined interval.
    %
    % Parameters : intervals - a struct comprised of start and end x interval and
    % start and end time intervals.
    %              numberOfPoints - the number of points in a defined interval
    %
    % Return     : a struct comprised of a grid parameters
    %
    % Examples of Usage:
    %
    %
    %    >> interval = {};
    %    >> interval.StartTime = 0;
    %    >> interval.EndTime = 3;
    %    >> interval.StartPosition = -8;
    %    >> interval.EndPosition = 8;
    %    >> multiplier = 30;
    %    >> grid = ComputeGrid(interval,numberOfPoints)
    %    ans =
    %    struct with fields:
    %
    %                Nx: 155
    %                Nt: 155
    %                Dx: 0.1097
    %                Dt: 0.0258
    %                 X: [-8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8]
    %                 T: [0 1 2 3]
    %                 U: [155�155 double]
    %    PerturbedGridA: {}
    %    PerturbedGridB: {}
    %      GroundTruthA: {}
    %      GroundTruthB: {}
    %
    %

    startTime = intervals.startTime;
    endTime = intervals.endTime;
    startPosition = intervals.startPos;
    endPosition = intervals.endPos;

    if (mod(endPosition - startPosition, 2) == 0)
        leftHalf = linspace(startPosition, 0, (numberOfPoints / 2) - 1);
        rightHalf = linspace(0, endPosition, (numberOfPoints / 2) - 1);
        grid.X = [leftHalf(1:end - 1) rightHalf]; %startPosition:endPosition;
    else
        grid.X = linspace(startPosition, endPosition, numberOfPoints);
    end

    grid.T = linspace(startTime, endTime, length(grid.X)); % startTime:grid.Dt:endTime; %startTime:endTime;
    grid.Dx = abs(grid.X(1) - grid.X(2));
    grid.Dt = abs(grid.T(1) - grid.T(2));

    grid.Nx = length(grid.X);
    grid.Nt = length(grid.T);

    grid.U = zeros(grid.Nx, grid.Nt);

    grid.PerturbedGridA = grid.U;
    grid.PerturbedGridB = grid.U;

    grid.GroundTruthA = grid.U;
    grid.GroundTruthB = grid.U;

    grid.ZeroPointTime = FindZeroPoint(grid.T);
    grid.ZeroPointPosition = FindZeroPoint(grid.X);
end

function zeroPoint = FindZeroPoint(list)
    l = 1;

    while list(l + 1) < 0
        l = l + 1;
    end

    % at this point we know l+1 is the transition from neg to pos
    % hence we take the difference between the 2 values the closest one to zero
    % is the one we treat as 0
    zeroPoint = 0;

    if abs(list(l)) < abs(list(l + 1))
        zeroPoint = l;
    else
        zeroPoint = l + 1;
    end

end
