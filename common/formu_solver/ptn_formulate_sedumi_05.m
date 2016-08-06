function [formulate_form_sedumi] = ptn_formulate_sedumi_05(ptn_info, pen_digit_case)
%% [formulate_form_sedumi] = ptn_formulate_sedumi_05(ptn_info, pen_digit_case)
%% Matrix Construction Guidlines
%%      first 1 var: offset
%%      following ptn_info.dim_feature * ptn_info.dim_feature variables:
%%           symmetric matrix
%%      following N: non-negative variable, error
%%      following N: non-negative slack variable
%%      following 1 variable: sum square error;
%%      following ptn_info.dim_feature: first order coefficience
%%      following ptn_info.dim_feature * (ptn_info.dim_feature+1)/2: upper
%%          right half matrix
%% Total Number of variables:
%%      1 + ptn_info.dim_feature * ptn_info.dim_feature + 2 * ptn_info.N +
%%          1 + ptn_info.dim_feature + 
%%             (ptn_info.dim_feature + 1)*ptn_info.dim_feature /2 
%% Total Number of constraints
%%      ptn_info.N + ptn_info.dim_feature * ptn_info.dim_feature

total_constr = ptn_info.N + ptn_info.dim_feature * ptn_info.dim_feature;
total_var = 1 + ptn_info.dim_feature * ptn_info.dim_feature + 2 * ptn_info.N + 1 + ptn_info.dim_feature + ...
    (ptn_info.dim_feature + 1)*ptn_info.dim_feature /2;

MatrixA = sparse(total_constr, total_var);
%%% Formulate the constraints
error_var_start_index = ptn_info.dim_feature * ptn_info.dim_feature + 1;
slack_var_start_index = ptn_info.dim_feature * ptn_info.dim_feature + 1 + ptn_info.N;
var_1st_ord_start = ptn_info.dim_feature * ptn_info.dim_feature + 2 * ptn_info.N + 2;
for ii = 1:1:ptn_info.N
    omega_squre = pen_digit_case(ii).feature' * pen_digit_case(ii).feature/ptn_info.scale_feature_factor/ptn_info.scale_feature_factor;
    if ptn_info.model_class_id == pen_digit_case(ii).class
        MatrixA(ii, 1) = 1;
        psd_variable_list = 1 + 1;
        for jj = 1:1:ptn_info.dim_feature
            for kk = 1:1:ptn_info.dim_feature
                MatrixA(ii, psd_variable_list) = omega_squre(jj, kk);
                psd_variable_list = psd_variable_list + 1;
            end
        end
        for jj = 1:1:ptn_info.dim_feature
            MatrixA(ii, var_1st_ord_start + jj) = pen_digit_case(ii).feature(jj)/ptn_info.scale_feature_factor;
        end
    else
        MatrixA(ii, 1) = -1;
        psd_variable_list = 1 + 1;
        for jj = 1:1:ptn_info.dim_feature
            for kk = 1:1:ptn_info.dim_feature
                MatrixA(ii, psd_variable_list) = -omega_squre(jj, kk);
                psd_variable_list = psd_variable_list + 1;
            end
        end
        for jj = 1:1:ptn_info.dim_feature
            MatrixA(ii, var_1st_ord_start + jj) = - pen_digit_case(ii).feature(jj)/ptn_info.scale_feature_factor;
        end
    end
    MatrixA(ii, ii+ error_var_start_index) = 1;   % variable indicating the error distance between the model output and the class_id
    MatrixA(ii, ii+ slack_var_start_index) = -1;   % variable indicating the error distance between the model output and the class_id
    RHS(ii, 1) = 1;
end

matrix_entry_index = 2;
half_symmetric_matrix_var_index = 1 + ptn_info.dim_feature * ptn_info.dim_feature + 2 * ptn_info.N + 1 + ptn_info.dim_feature + 1;
for ii = 1:1:ptn_info.dim_feature
    for jj = 1:1:ptn_info.dim_feature
        matrix_entry(ii, jj) = matrix_entry_index;
        matrix_entry_index = matrix_entry_index + 1;
        if ii <= jj
            half_sym_mtrix_entry(ii, jj) = half_symmetric_matrix_var_index;
            half_symmetric_matrix_var_index = half_symmetric_matrix_var_index + 1;
        end
    end
end
constrain_index = ptn_info.N + 1;
for ii = 1:1:ptn_info.dim_feature
    for jj = 1:1:ptn_info.dim_feature
        if ii <= jj
            MatrixA(constrain_index, matrix_entry(ii, jj)) = 1;
            MatrixA(constrain_index, half_sym_mtrix_entry(ii, jj)) = -1;
        else
            MatrixA(constrain_index, matrix_entry(ii, jj)) = 1;
            MatrixA(constrain_index, matrix_entry(jj, ii)) = -1;
        end
        RHS(constrain_index, 1) = 0;
        constrain_index = constrain_index + 1;
    end
end
RHS = sparse(RHS);

%%% The cost vector
c = sparse([zeros(1 + ptn_info.dim_feature * ptn_info.dim_feature, 1); ptn_info.penalty * ones(ptn_info.N, 1); zeros(ptn_info.N, 1);...
    1; zeros(ptn_info.dim_feature + ptn_info.dim_feature * (ptn_info.dim_feature + 1)/2, 1)]);

%%% First ptn_info.dim_feature variables are free
K.f = 1 + ptn_info.dim_feature * ptn_info.dim_feature;
%%% non-negative variables
K.l = ptn_info.N * 2;
%%% following 1 + ptn_info.dim_feature + ptn_info.dim_feature * (ptn_info.dim_feature + 1)/2 variables subject to a quadratic cone
K.q = 1 + ptn_info.dim_feature + ptn_info.dim_feature * (ptn_info.dim_feature + 1)/2;

%%% Then ptn_info.dim_feature * ptn_info.dim_feature variables PSD cone
%K.s = ptn_info.dim_feature;

formulate_form_sedumi.A = MatrixA;
formulate_form_sedumi.b = RHS;
formulate_form_sedumi.c = c;
formulate_form_sedumi.K = K;

