function grid = PerformNovelStabilityAnalysis(functions, grid)

    metadata = functions.Metadata;

    da = [];
    db = [];
    
    plotResults = false;
    
    tempA = grid.PerturbedGridA;
    tempB = grid.PerturbedGridB;
    grid.PerturbedGridAA = [tempA(1:3,:); tempA(4:end, :) * 0];
    grid.PerturbedGridBB = [tempB(1:3,:); tempB(4:end, :) * 0];
    
    grid.PerturbedGridAA = grid.PerturbedGridA;
    grid.PerturbedGridBB = grid.PerturbedGridB;
    
    outputA = [tempA(1,:); tempA(2:end, :) * 0];
    outputB = [tempB(1,:); tempB(2:end, :) * 0];
    
    if metadata.Version == 2
        % compute coefficient matrix
        [grid.A_coeff, grid.B_coeff] = ComputeCoefficientMatrix(functions, grid);
        % define conditions at the boundaries
        Un_a(1) = grid.PerturbedGridAA(1, 1); Un_a(grid.Nx) = grid.PerturbedGridAA(1, end);
        Un_b(1) = grid.PerturbedGridBB(1, 1); Un_b(grid.Nx) = grid.PerturbedGridBB(1, end);
                
        for i = 2:length(grid.T)-1 % T > delta T ... we skip the 1st time point since it is the initial condition and last time point since it is the boundary condition
           for j = 2:length(grid.X)-1  % -N <= j <= N
              % condition on cases where  j is an initial first boundary
              [DaVal, DbVal] = ComputeAtCurrentTimeAndPosition(i, j, grid);
              
              % the problem lies above as we see a 4000 difference in magnitude
              % between the last time point in the perturbed grid and the
              % current computed Da and Db values
              
              da(j-1,1) = DaVal;
              db(j-1,1) = DbVal;
           end
           
           % diff = ((abs(da') - abs(grid.PerturbedGridA(2:end-1, i-1))) / abs(grid.PerturbedGridA(2:end-1, i-1)')) * 100;

                      
           UU_a = grid.A_coeff.AA_inv * da; 

           % diff = ((abs(UU_a') - abs(grid.PerturbedGridA(2:end-1, i-1))) / abs(grid.PerturbedGridA(2:end-1, i-1)')) * 100;
           
           Un_a = [Un_a(1), UU_a', Un_a(grid.Nx)];
           % diff = ((abs(Un_a) - abs(grid.PerturbedGridA(:, i-1))) / abs(grid.PerturbedGridA(:, i-1)')) * 100;
           
           % place the current set of amplitudes for all positions at the
           % current time which is i
           
           % compute the gradient between the current found amplitude at time tx
           % and it equivalent in the ground truth at time tc
           [dx_ap, dy_ap] = gradient(grid.PerturbedGridAA);
           
           grid.PerturbedGridAA(i, :) = Un_a; 
           outputA(i, :) = Un_a;
           [dx_as, dy_as] = gradient(abs(grid.PerturbedGridAA));
           
           dx = abs((dx_ap - dx_as) / dx_ap);
           dy = abs((dy_ap - dy_as) / dy_ap);
           
           
           UU_b = grid.B_coeff.BB_inv * db;
           Un_b = [Un_b(1), UU_b', Un_b(grid.Nx)];
           % place the current set of computed amplitudes for all positions at
           % the current time which is i
           grid.PerturbedGridBB(i, :) = Un_b; 
           outputB(i, :) = Un_b;
            
           max(max(grid.PerturbedGridAA .* conj(grid.PerturbedGridAA)))
        
         if plotResults == true
               subplot(3,1,1)
               mesh(grid.X,grid.T, abs(outputA),'FaceAlpha','0.1');
               %shold1 = mesh(grid.X,grid.T,abs(grid.GroundTruthA));
               title("Wave Stabilization (Case A) iteration " + i + " Max Amplitude" + max(max(abs(outputA)))); 
               xlabel("Space")
               ylabel("Time")
               zlabel("Amplitude");
               view(30,45)
               axis on;
               hold on
               %shold1 = mesh(grid.X,grid.T,abs(grid.GroundTruthA));

               subplot(3,1,2)
               mesh(grid.X,grid.T, abs(outputB),'FaceAlpha','0.1');
               %shold2 = mesh(grid.X,grid.T,abs(grid.GroundTruthB));
               title("Wave Stabilization (Case B) iteration " + i + " Max Amplitude" + max(max(abs(outputB))))
               xlabel("Space")
               ylabel("Time")
               zlabel("Amplitude")
               view([30 45]);                         % change the viewing angle - see doc view
               axis on;
               hold on;
               
               
               subplot(3,1,3)
               mesh(dx_as, dy_as);
               
               F(i) = getframe(gcf);
               drawnow;
               pause(0.001);
               fr = F;
         end
        end
    end
    
    grid.PerturbedGridAA = outputA;
    grid.PerturbedGridBB = outputB;
end

function result =  ComputeArrayMagnitude(Arr)
    result =  zeros(1, length(Arr));
    for i = 1:length(Arr)
       result(1, i) =  abs(Arr(1, i)); 
    end
end

function [Da, Db] = ComputeAtCurrentTimeAndPosition(n, m, grid)
    if m == 1
       me = MException('time must be greater than 1');
       throw(me);
    end
    
    firstTermOfA =  grid.A_coeff.c * grid.PerturbedGridAA(n, m-1);
    secondTermOfA =  grid.A_coeff.d1j(grid.PerturbedGridAA(n, m), grid.PerturbedGridBB(n, m)) * grid.PerturbedGridAA(n, m);
    thirdTermOfA = grid.A_coeff.d2j(grid.PerturbedGridAA(n, m+1), grid.PerturbedGridBB(n, m+1)) * grid.PerturbedGridAA(n, m+1);

    firstTermOfB =  grid.B_coeff.c * grid.PerturbedGridBB(n, m-1);
    secondTermOfB =  grid.B_coeff.d1j(grid.PerturbedGridAA(n, m), grid.PerturbedGridBB(n, m)) * grid.PerturbedGridBB(n, m);
    thirdTermOfB = grid.B_coeff.d2j(grid.PerturbedGridAA(n, m+1), grid.PerturbedGridBB(n, m+1)) * grid.PerturbedGridBB(n, m+1);
    
    if n == 1
        fourthTermOfA = grid.A_coeff.a * grid.PerturbedGridAA(n+1, m);
        fourthTermOfB = grid.B_coeff.a * grid.PerturbedGridBB(n+1, m);
        
        Da = firstTermOfA + secondTermOfA + thirdTermOfA - fourthTermOfA;
        Db = firstTermOfB + secondTermOfB + thirdTermOfB - fourthTermOfB;
    elseif (n > 1 && n < grid.Nx-2)
        fourthTermOfA = grid.A_coeff.a * grid.PerturbedGridAA(n+1, m);
        fourthTermOfB = grid.B_coeff.a * grid.PerturbedGridBB(n+1, m);
            
        fifthTermOfA =  grid.A_coeff.a * grid.PerturbedGridAA(n-1, m);
        fifthTermOfB =  grid.B_coeff.a * grid.PerturbedGridBB(n-1, m);

        Da = firstTermOfA + secondTermOfA + thirdTermOfA - fourthTermOfA - fifthTermOfA;
        Db = firstTermOfB + secondTermOfB + thirdTermOfB - fourthTermOfB - fifthTermOfB;
    else 
        fifthTermOfA =  grid.A_coeff.a * grid.PerturbedGridAA(n-1, m);
        fifthTermOfB =  grid.B_coeff.a * grid.PerturbedGridBB(n-1, m);

        Da = firstTermOfA + secondTermOfA + thirdTermOfA - fifthTermOfA;
        Db = firstTermOfB + secondTermOfB + thirdTermOfB - fifthTermOfB;
    end
    
end

function [A_coeff, B_coeff] = ComputeCoefficientMatrix(functions, grid)
    metadata = functions.Metadata;
    constraints = functions.Constraints;

    A_coeff = {};
    B_coeff = {};
    
    A_coeff.a = constraints.P1 / (2 * (grid.Dx^2));
    A_coeff.b = (1i / (2 * (grid.Dt^2))) - (constraints.P1 / (grid.Dx^2)) - ((1i * constraints.Gamma1) / 2);
    A_coeff.c = (1i / (2 * (grid.Dt^2)));
    A_coeff.d1j = @(currentTimeAmpA, currentTimeAmpB) (constraints.P1 / ((grid.Dx^2))) + ((1i * constraints.Gamma1) / 2) ...
        - 0.5 * (constraints.Q1 * (conj(currentTimeAmpA) * (currentTimeAmpA)) + constraints.Q2 * (conj(currentTimeAmpB) * (currentTimeAmpB)));
    A_coeff.d2j = @(nextTimeAmpA, nextTimeAmpB)...
        - 0.5 * (constraints.Q1 * (conj(nextTimeAmpA) * (nextTimeAmpA)) + constraints.Q2 * (conj(nextTimeAmpB) * (nextTimeAmpB)));

    a = A_coeff.a * ones(grid.Nx-3, 1);
    b = A_coeff.b * ones(grid.Nx-2, 1);
    c = A_coeff.c * ones(grid.Nx-3, 1);
    A_coeff.AA = diag(b) + diag(c, 1) + diag(a, -1);
    A_coeff.AA_inv = inv(A_coeff.AA);

    B_coeff.a = constraints.P1_prime / (2 * (grid.Dx^2));
    B_coeff.b = (1i / (2 * (grid.Dt^2))) - (constraints.P1_prime / (grid.Dx^2)) - ((1i * constraints.Gamma1_prime) / 2);
    B_coeff.c = (1i / (2 * (grid.Dt^2)));
    B_coeff.d1j = @(currentTimeAmpA, currentTimeAmpB) (constraints.P1_prime / ((grid.Dx^2))) + ((1i * constraints.Gamma1_prime) / 2) ...
        - 0.5 * (constraints.Q1_prime * (conj(currentTimeAmpA) * (currentTimeAmpA)) + constraints.Q2_prime * (conj(currentTimeAmpB) * (currentTimeAmpB)));
    B_coeff.d2j = @(nextTimeAmpA, nextTimeAmpB)...
        - 0.5 * (constraints.Q1_prime * (conj(nextTimeAmpA) * (nextTimeAmpA)) + constraints.Q2_prime * (conj(nextTimeAmpB) * (nextTimeAmpB)));

    a = B_coeff.a * ones(grid.Nx-3, 1);
    b = B_coeff.b * ones(grid.Nx-2, 1);
    c = B_coeff.c * ones(grid.Nx-3, 1);
    B_coeff.BB = diag(b) + diag(c, 1) + diag(a, -1);    
    B_coeff.BB_inv = inv(B_coeff.BB);

end

