function constraints = ComputeConstraints(solutionMetadata)
    % function constatins = ComputeConstraints(solutionMetadata)
    %
    % Author1: Yoan Yomba (yoyomba@microsoft.com)
    % Date:    Winter 2021
    % Application:  Cubic Quintic Ginzburg Landau
    %
    % Function   : ComputeConstraints
    %
    % Description: Computes the constraints associated with a given solution type
    %
    % Parameters : solutionMetadata   - a struct comprised of solution specific
    % details which include WaveType, CaseType, CaseLetter, and Version.
    %
    % WaveType is a string taking the following values: Bright-Bright, Dark-Dark, Front-Front.
    % CaseType is an interger taking the following values: 1, 2, 3
    % CaseLetter is a string corresponding to the given case letter we make use of
    % Version is tied to paper version we seek to implement: Version 1 is tied to the old paper while 2 corresponds to the new paper
    %
    % Return     : a struct comprised of a set of constraints
    %
    % Examples of Usage:
    %
    %
    %    >> metadata = {};
    %    >> metadata.WaveType = "Bright-Bright";
    %    >> metadata.CaseType = 1;
    %    >> metadata.Version = 2;
    %    >> constraints = ComputeConstraints(metadata)
    %    ans =
    %   constraints =
    %
    %  struct with fields:
    %
    %              k1: 0.1133 + 0.9911i
    %              K1: 0
    %              W1: 0.0000 - 3.4699i
    %           Eta_s: 178.0359
    %            Mu_s: 247.3202
    %          Omega1: 0
    %          Omega2: 0
    %            Beta: 8.7485
    %           Alpha: -8.6572
    %             Q2r: 0
    %          Gamma1: -1.7500
    %    Gamma1_prime: -6.1599
    %              P1: 3.0000 + 2.5000i
    %        P1_prime: 2.0000 + 6.8171i
    %              Q1: -1.0000 + 2.4000i
    %              Q2: 0.0000 - 1.7500i
    %        Q1_prime: 0.6000 - 3.0000i
    %        Q2_prime: -0.5000 + 2.0650i
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
        cons = 1e-2 * 0.2;
        cons2 = 1e-150;

        if metadata.WaveType == "Bright-Bright"

            if metadata.CaseType == 1
                constraints.startTime = 0;
                constraints.endTime = 3;
                constraints.startPos = -8;
                constraints.endPos = 2;

                constraints.L = cons;
                constraints.k1 = complex(1.0417810279445396, 0.5295590088750854);
                constraints.K1 = 0;
                constraints.K2 = 0;
                constraints.W1 = complex(3.5000000000000036, 2.2563808753624817);
                constraints.Eta_s = 17.364923362962905;
                constraints.Mu_s = 52.094770088888716;
                constraints.Omega1 = 0;
                constraints.Omega2 = 0;
                constraints.Beta = 1.0458028182282497;
                constraints.Alpha = 1.31454380654842;
                constraints.Q2r = -0.7291666666666667;
                constraints.Gamma1 = complex(6.511613080797135, 1.75) / (constraints.L^2);
                constraints.Gamma1_prime = complex(4.797919755978034, -2.9166666666666667) / (constraints.L^2);

                constraints.P1 = complex(2, 1);
                constraints.P1_prime = complex(3, -2.5);
                constraints.Q1 = complex(1, -2.4);
                constraints.Q2 = complex(-0.7291666666666667, 1.75);
                constraints.Q1_prime = complex(0.6, -3);
                constraints.Q2_prime = complex(-0.5, 2.25);
            elseif metadata.CaseType == 2
                constraints.startTime = 0; %0;
                constraints.endTime = 40; %40
                constraints.startPos = -50; %50
                constraints.endPos = 50; %50

                constraints.L = cons2;
                constraints.k1 = (0.01283462537560516) + (1i * 0.9911184493673615);
                constraints.K1 = 0;
                constraints.W1 = 0 - (1i * 3.4698625394455194);
                constraints.Eta_s = 178.03586557962788;
                constraints.Mu_s = 247.320185920484;
                constraints.Omega1 = 0;
                constraints.Omega2 = 0;
                constraints.Beta = 8.748507371478683;
                constraints.Alpha = -8.657221966458971;

                constraints.Q2r = 0;
                constraints.Gamma1 = -1.75 + (1i * 0) / (constraints.L^2);
                constraints.Gamma1_prime = -6.1599157711868955 + (1i * 0) / (constraints.L^2);

                constraints.P1 = 3 + (1i * 2.5);
                constraints.P1_prime = 2 + (1i * 6.817101079155266);
                constraints.Q1 = -1 + (1i * 2.4);
                constraints.Q2 = 0 - (1i * 1.75);
                constraints.Q1_prime = 0.6 + (1i * -3);
                constraints.Q2_prime = -0.5 + (1i * 2.065);
            end

        elseif metadata.WaveType == "Dark-Dark"

            if metadata.CaseType == 1
                % x -10 to 35 t = 0 to 3
                constraints.startTime = 0;
                constraints.endTime = 3;
                constraints.startPos = -10;
                constraints.endPos = 35;

                constraints.L = 1e-150;

                % done
                constraints.Beta = 1.7451982704913325;
                constraints.Alpha = -2.144007467651334;
                constraints.Eta_s = 0.6178480071311616;
                constraints.Mu_s = 0.009808447362978197;
                constraints.Omega1 = 10.144412552072561;
                constraints.Omega2 = 21.083022658796274;
                constraints.Gamma1 = complex(1.5, 1.75) / (constraints.L^2);
                constraints.Gamma1_prime = complex(-1.8314750148267838, 1.25) / (constraints.L^2);
                constraints.Q2r = -1.25;
                constraints.Q2 = complex(-1.25, 1.75);
                constraints.Q2_prime = complex(-0.5, 2.25);
                constraints.Q1 = complex(1, 2.4);
                constraints.Q1_prime = complex(0.6, -3);

                constraints.k1 = sqrt(0.11660407147455695);
                constraints.K1 = 2.5;
                constraints.K2 = 2.750686413691043;
                constraints.W1 = -4.414733832593061;

                constraints.P1 = complex(2, 0);
                constraints.P1_prime = complex(3, 0);
            elseif metadata.CaseType == 2
                % x -0.5 to 0.5 t = 0 to 1
                constraints.startTime = 0;
                constraints.endTime = 1;
                constraints.startPos = -0.05;
                constraints.endPos = 0.5;

                constraints.L = cons2;

                % done
                constraints.k1 = sqrt(153.26683828438394);
                constraints.K1 = 5;
                constraints.K2 = 21.6248760069397;
                constraints.Eta_s = 0.6191867854483949;
                constraints.Mu_s = 0.00797240852791569;
                constraints.Beta = 1.7456832294800957;
                constraints.Alpha = -2.1490753463338934;
                constraints.W1 = -7.821410399458799;
                constraints.Omega1 = 47.640778725211504;
                constraints.Omega2 = 56.92452128936377;
                constraints.P1 = complex(2, 0);
                constraints.P1_prime = complex(3, 0);
                constraints.Q1 = complex(1, 2.4);
                constraints.Q1_prime = complex(0.6, -3);
                constraints.Gamma1 = complex(1.5, 1.75) / (constraints.L^2);

                constraints.Gamma1_prime = complex(-4.598004125481732e-7, 1.25) / (constraints.L^2);
                constraints.Q2r = -1.25;
                constraints.Q2 = complex(-1.25, 1.75);
                constraints.Q2_prime = complex(-0.75, 3.75);
            end

        elseif metadata.WaveType == "Front-Front"

            if metadata.CaseType == 1
                % x -10 to 35 t = 0 to 3
                constraints.startTime = 0;
                constraints.endTime = 3;
                constraints.startPos = -70;
                constraints.endPos = 70;

                constraints.L = cons;

                constraints.Alpha = 0.1781479115112448;
                constraints.Beta = -1.414213562373095;
                constraints.Q2r = -3.5751561628522968;
                constraints.Q2 = complex(-3.5751561628522968, 8.580374790845513);
                constraints.Q1_prime = complex(-0.209781046152021, 1.048905230760105);
                constraints.k1 = sqrt(0.10049293010631864);
                constraints.K1 = 0.04890336489571538;
                constraints.K2 = 0.5683582642314903;
                constraints.Eta_s = 0.60971484582254;
                constraints.Mu_s = 0.17054215761476085;
                constraints.Omega1 = -1.135502075981213;
                constraints.Omega2 = -0.23827111103561216;
                constraints.W1 = -1.567689709658571;
                constraints.P1 = complex(2, -15.339230729988305);
                constraints.P1_prime = complex(3, 0.6);
                constraints.Q1 = complex(-1, 2.4);
                constraints.Gamma1 = complex(1.5, 1.75) / (constraints.L^2);
                constraints.Gamma1_prime = complex(0.019359027106311898, 1.25) / (constraints.L^2);
                constraints.Q2_prime = complex(-0.75, 3.75);
            elseif metadata.CaseType == 2
                % x -0.5 to 0.5 t = 0 to 1
                constraints.startTime = 0;
                constraints.endTime = 2;
                constraints.startPos = -2;
                constraints.endPos = 2;

                constraints.L = cons2;
                constraints.Alpha = 0.08187621570341645;
                constraints.Beta = -2.091133922898288;
                constraints.Q2r = -0.12438483609473883;
                constraints.Q2 = complex(-0.12438483609473883, 0.21323114759098083);
                constraints.Q1_prime = complex(-2.813847820914596, 3.376617385097515);
                constraints.k1 = sqrt(579980.8016216066);
                constraints.K1 = 194.6279677165143;
                constraints.K2 = -581.0420874804896;
                constraints.Eta_s = 1.1691069333364856;
                constraints.Omega1 = -0.8899570962652534;
                constraints.Omega2 = -0.3108984400357673;
                constraints.W1 = -1.7601156501386148;
                constraints.Mu_s = 6.579377993570032;
                constraints.P1 = complex(0.0000011, -2.56260724878725e-6);
                constraints.P1_prime = complex(0.0000013, 0.0000023);
                constraints.Q1 = complex(-0.7, 1.2);
                constraints.Gamma1 = complex(1.5, 1.75) / (constraints.L^2);
                constraints.Gamma1_prime = complex(1.5944612214966543, 1.25) / (constraints.L^2);
                constraints.Q2_prime = complex(-0.5, 0.6);
            end

        end

    end
