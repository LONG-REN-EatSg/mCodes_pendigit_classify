function [ptn_kessler_formulation] = ptn_linear_kessler_formulate(ptn_info, pen_digit_case)
%
% ptn_kessler_formulation
%    MatrixY:
%    Rhs    :
%

n_c = zeros(ptn_info.total_class, 1);
start_row_class_Y = zeros(ptn_info.total_class, 1);

%% for all samples, calculate the total number of samples for each class
for ii = 1:1:ptn_info.N
    n_c(pen_digit_case(ii).class + 1) = n_c(pen_digit_case(ii).class + 1) + 1;
end

%% to prepare for constructing the matrix
for ii = 1:1:ptn_info.total_class
    if ii == 1
        start_row_class_Y(ii) = 0;
    else
        start_row_class_Y(ii) = n_c(ii - 1) + start_row_class_Y(ii-1);
    end
end

Rhs = sparse([], [], [], ptn_info.N, ptn_info.total_class, ptn_info.N);
row_count_class = zeros(ptn_info.total_class, 1);
for ii = 1:1:ptn_info.N
    curr_class_id = pen_digit_case(ii).class + 1;
    row_count_class(curr_class_id) = row_count_class(curr_class_id) + 1;
    ptn_kessler_formulation.MatrixY(start_row_class_Y(curr_class_id) + row_count_class(curr_class_id), :) = [1, pen_digit_case(ii).feature];
    Rhs(start_row_class_Y(curr_class_id) + row_count_class(curr_class_id), curr_class_id) = 1;
end

ptn_kessler_formulation.Rhs = Rhs;
ptn_kessler_formulation.MatrixY_p = inv(ptn_kessler_formulation.MatrixY' * ptn_kessler_formulation.MatrixY)*ptn_kessler_formulation.MatrixY';
ptn_kessler_formulation.ro = ptn_info.kessler_ro;
