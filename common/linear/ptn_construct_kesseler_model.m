function [model_linear] = ptn_construct_kesseler_model(ptn_kessler_solution)
%
%
%
[feature_p, num_class] = size(ptn_kessler_solution.SolutionA);

for ii = 1:1:num_class
    model_linear(ii).class_id = ii - 1;
    model_linear(ii).factor = ptn_kessler_solution.SolutionA(2:feature_p, ii);
    model_linear(ii).offset = ptn_kessler_solution.SolutionA(1, ii);
end

