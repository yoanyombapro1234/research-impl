function functions = ComputeFunctionsAndRelatedFields(solutionMetadata)
    % function constatins = ComputeFunctionsAndRelatedFields(solutionMetadata)
    %
    % Author1: Yoan Yomba (yoyomba@microsoft.com)
    % Date:    Winter 2021
    % Application:  Cubic Quintic Ginzburg Landau
    %
    % Function   : ComputeFunctionsAndRelatedFields
    %
    % Description: Defines lambda functions representation corresponding to A(x,t)
    % and B(x,t).
    %
    % Parameters : solutionMetadata   - a struct comprised of solution specific
    % details which include WaveType, CaseType, CaseLetter, and Version.
    %
    % WaveType is a string taking the following values: Bright-Bright, Dark-Dark, Front-Front.
    % CaseType is an interger taking the following values: 1, 2, 3
    % CaseLetter is a string corresponding to the given case letter we make use of
    % Version is tied to paper version we seek to implement: Version 1 is tied to the old paper while 2 corresponds to the new paper
    %
    % Return     : a struct comprised of a set of lambda functions A(x,t) and
    % B(x,t), Constraints, and Metadata
    %
    % Examples of Usage:
    %
    %
    %    >> metadata = {};
    %    >> metadata.WaveType = "Bright-Bright";
    %    >> metadata.CaseType = 1;
    %    >> metadata.Version = 2;
    %    >> functions = ComputeFunctionsAndRelatedFields(metadata)
    %    ans =
    %           constraints =
    %
    %  struct with fields:
    %
    %              A: [function_handle]
    %              B: [function_handle]
    %    Constraints: [1�1 struct]
    %       Metadata: [1�1 struct]
    %
    %
    metadata = solutionMetadata;
    constraints = {};

    if (nargin < 1)
        metadata.CaseType = 1;
        metadata.CaseLetter = "A";
        metadata.WaveType = "Bright-Bright";
        metadata.Version = 2;
    end

    if metadata.Version == 2

        if (metadata.CaseType == 1 || metadata.CaseType == 2) && (metadata.WaveType == "Bright-Bright")
            % compute the lambda for A(x,t)
            functions.A = @(x, t, constraints) ...
                (constraints.Eta_s * exp((2 * x * real(constraints.k1)) + (2 * t * real(constraints.W1)))) / ...
                (1 + exp((2 * x * real(constraints.k1)) + (2 * t * real(constraints.W1))))^2;

            % compute the lambda for B(x,t)
            functions.B = @(x, t, constraints) ...
                constraints.Mu_s * exp((2 * x * real(constraints.k1)) + (2 * t * real(constraints.W1))) / ...
                (1 + exp((2 * x * real(constraints.k1)) + (2 * t * real(constraints.W1))))^2;

            % compute the constraints
            functions.Constraints = ComputeConstraints(metadata);

            % associate the metadata parameters to the function of interest
            functions.Metadata = metadata;
        elseif (metadata.CaseType == 1 || metadata.CaseType == 2) && (metadata.WaveType == "Dark-Dark")
            % compute the lambda for A(x,t)
            functions.A = @(x, t, constraints) ...
                (constraints.Eta_s * (1 - exp(2 * (x * real(constraints.k1) + (t * real(constraints.W1)))))^2) / ...
                (1 + exp(2 * (x * real(constraints.k1) + (t * real(constraints.W1)))))^2;

            % compute the lambda for B(x,t)
            functions.B = @(x, t, constraints) ...
                constraints.Mu_s * (1 - exp(2 * (x * real(constraints.k1)) + (t * real(constraints.W1))))^2 / ...
                (1 + exp(2 * (x * real(constraints.k1)) + (t * real(constraints.W1))))^2;

            % compute the constraints
            functions.Constraints = ComputeConstraints(metadata);

            % associate the metadata parameters to the function of interest
            functions.Metadata = metadata;
        elseif (metadata.CaseType == 1 || metadata.CaseType == 2) && (metadata.WaveType == "Front-Front")
            % compute the lambda for A(x,t)
             functions.A = @(x, t, constraints) ...
                (constraints.Eta_s) / ...
                (1 + exp(x * real(constraints.k1) + (t * real(constraints.W1))))^2;

            % compute the lambda for B(x,t)
            functions.B = @(x, t, constraints) ...
                constraints.Mu_s * (exp((2 * x * real(constraints.k1)) + (2 * t * real(constraints.W1)))) / ...
                (1 + exp((x * real(constraints.k1)) + (t * real(constraints.W1))))^2;

            % compute the constraints
            functions.Constraints = ComputeConstraints(metadata);

            % associate the metadata parameters to the function of interest
            functions.Metadata = metadata;
        end

    end

end
