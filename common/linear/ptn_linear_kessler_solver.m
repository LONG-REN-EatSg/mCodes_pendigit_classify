function [ptn_kessler_solution] = ptn_linear_kessler_solver(ptn_kessler_formulation)
%
%
%

MaxIter = 100;
EPSLON = 1e-3;
[m, n] = size(ptn_kessler_formulation.Rhs);
ro = ptn_kessler_formulation.ro;

B = ptn_kessler_formulation.Rhs;
Solution = ptn_kessler_formulation.MatrixY_p * B;
Error = ptn_kessler_formulation.MatrixY * Solution - B;
MSE(1) = norm(Error);
iter = 1;

while MSE(iter) > EPSLON
    for ii = 1:1:m
        for jj = 1:1:n
            if Error(ii, jj) >= 0
                Error_positive(ii, jj) = Error(ii, jj);
            else
                Error_positive(ii, jj) = 0;
            end
        end
    end
    B = B + 2 * ro * Error_positive;
    Solution = ptn_kessler_formulation.MatrixY_p * B;
    Error = ptn_kessler_formulation.MatrixY * Solution - B;
    MSE(iter + 1) = norm(Error);
    iter = iter + 1;
    
    if iter > MaxIter
        strText = sprintf('Exceed maximum iteration, remain error: %5.2f', MSE(iter));
        disp(strText);
        break;
    end
end

ptn_kessler_solution.SolutionA = Solution;
ptn_kessler_solution.MSE = MSE;
ptn_kessler_solution.Rhs = B;