function [formulate_form_mosek] = ptn_formulate_mosek_02(ptn_info, pen_digit_case, Model_Ord2)
%% [formulate_form_mosek] = ptn_formulate_mosek_05(ptn_info, pen_digit_case)
%% Matrix Construction Guidlines
%%      first 1 var: offset
%%      following ptn_info.dim_feature * ptn_info.dim_feature variables:
%%           symmetric matrix
%%      following N: non-negative variable, error
%%      following 1 variable: sum square error;
%%      following ptn_info.dim_feature: first order coefficience
%%      following ptn_info.dim_feature * (ptn_info.dim_feature+1)/2: upper
%%          right half matrix
%% Total Number of variables:
%%      1 + ptn_info.dim_feature * ptn_info.dim_feature + ptn_info.N +
%%          1 + ptn_info.dim_feature + 
%%             (ptn_info.dim_feature + 1)*ptn_info.dim_feature /2 
%% Total Number of constraints
%%      ptn_info.N + ptn_info.dim_feature * ptn_info.dim_feature

dim_feature = ptn_info.dim_feature;
N_samples = ptn_info.N;

total_constr = N_samples + dim_feature * dim_feature;
total_var = 1 + dim_feature * dim_feature + N_samples + 1 + dim_feature + ...
    (dim_feature + 1)*dim_feature /2;

%MatrixA = sparse(total_constr, total_var);
total_non_zero = (1 + dim_feature * dim_feature + dim_feature) * N_samples + N_samples + dim_feature * dim_feature * 2;
MatrixA = sparse([], [], [], total_constr, total_var, total_non_zero);

%%% construct the initial solution
psd_variable_list = 2;
for ii = 1:1:dim_feature
    for jj = 1:1:dim_feature
        x_init(psd_variable_list) = Model_Ord2.ModelMatrix(ii, jj);
        ord2_para_list(psd_variable_list - 1) = x_init(psd_variable_list);
        psd_variable_list = psd_variable_list + 1;
    end
end

para_1st_start_index = 1 + dim_feature * dim_feature + N_samples + 1;
x_init(para_1st_start_index + 1: para_1st_start_index+ dim_feature) = Model_Ord2.ModelLinearVec;

x_init(1) = Model_Ord2.ModelOffset;

%%% Formulate the constraints
%%% 1st kind of constraints: error from each model output to each sample
error_var_start_index = dim_feature * dim_feature + 1;
%slack_var_start_index = dim_feature * dim_feature + 1 + N_samples;
var_1st_ord_start = dim_feature * dim_feature + N_samples + 2;
for ii = 1:1:N_samples
    cov_mat_ii = ptn_info.scaled_feature(ii).cov_mat;
    scaled_vec_ii = ptn_info.scaled_feature(ii).vector;
    if ptn_info.model_class_id == pen_digit_case(ii).class
        MatrixA(ii, 1) = 1;
        psd_variable_list = 1 + 1;
        for jj = 1:1:dim_feature
            for kk = 1:1:dim_feature
                MatrixA(ii, psd_variable_list) = cov_mat_ii(kk, jj);
                psd_variable_list = psd_variable_list + 1;
            end
        end
        for jj = 1:1:dim_feature
            MatrixA(ii, var_1st_ord_start + jj) = scaled_vec_ii(jj);
        end
    else
        MatrixA(ii, 1) = -1;
        psd_variable_list = 1 + 1;
        for jj = 1:1:dim_feature
            for kk = 1:1:dim_feature
                MatrixA(ii, psd_variable_list) = -cov_mat_ii(kk, jj);
                psd_variable_list = psd_variable_list + 1;
            end
        end
        for jj = 1:1:dim_feature
            MatrixA(ii, var_1st_ord_start + jj) = - scaled_vec_ii(jj); 
        end
    end
    MatrixA(ii, ii+ error_var_start_index) = 1;   % variable indicating the error distance between the model output and the class_id
    RHS_Low(ii, 1) = 1;
    RHS_Upp(ii, 1) = inf;

    %%%% Initial Solution
    ord2_part = ord2_para_list * MatrixA(ii, 2:(dim_feature*dim_feature + 1))';
%    size_matrix_list = size( MatrixA(ii, (var_1st_ord_start + 1):(var_1st_ord_start + dim_feature)));
%    size_para_1st_ord = size(Model_Ord2.ModelLinearVec);
    ord1_part = MatrixA(ii, (var_1st_ord_start + 1):(var_1st_ord_start + dim_feature)) * Model_Ord2.ModelLinearVec;
    x_init(ii+ error_var_start_index) = RHS_Low(ii, 1) - ord2_part - ord1_part - Model_Ord2.ModelOffset * MatrixA(ii, 1);
    if mod(ii, 1000) == 0
        ii
    end
end

%%%% 2nd constraints: symmetric matrix, and slack variables for the conic
%%%% constraints
matrix_entry_index = 2;
half_symmetric_matrix_var_index = 1 + dim_feature * dim_feature + N_samples + 1 + dim_feature + 1;
for ii = 1:1:dim_feature
    for jj = 1:1:dim_feature
        matrix_entry(ii, jj) = matrix_entry_index;
        matrix_entry_index = matrix_entry_index + 1;
        if ii <= jj
            half_sym_mtrix_entry(ii, jj) = half_symmetric_matrix_var_index;
            half_symmetric_matrix_var_index = half_symmetric_matrix_var_index + 1;
        end
    end
end
constrain_index = N_samples + 1;
for ii = 1:1:dim_feature
    for jj = 1:1:dim_feature
        if ii <= jj
            MatrixA(constrain_index, matrix_entry(ii, jj)) = 1;
            MatrixA(constrain_index, half_sym_mtrix_entry(ii, jj)) = -1;
            x_init(half_sym_mtrix_entry(ii, jj)) = x_init(matrix_entry(ii, jj));   %%%% Initial Solution
        else
            MatrixA(constrain_index, matrix_entry(ii, jj)) = 1;
            MatrixA(constrain_index, matrix_entry(jj, ii)) = -1;
        end
        RHS_Upp(constrain_index, 1) = 0;
        RHS_Low(constrain_index, 1) = 0;
        constrain_index = constrain_index + 1;
    end
end
RHS_Upp = sparse(RHS_Upp);
RHS_Low = sparse(RHS_Low);

%%% The cost vector
c = sparse([zeros(1 + dim_feature * dim_feature, 1); ptn_info.penalty * ones(N_samples, 1); ...
    1; zeros(dim_feature + dim_feature * (dim_feature + 1)/2, 1)]);
%%% Range of variables
blx = sparse([ -inf * ones(1 + dim_feature * dim_feature, 1); ...
               zeros(N_samples + 1, 1); ...
               -inf * ones(dim_feature + dim_feature * (dim_feature + 1)/2, 1)]);

bux = sparse([ inf * ones(total_var, 1)]);

%%% conic constraints
cones = cell(1,1);
cones{1}.type = 'MSK_CT_QUAD';
root_sum_sq_var_id = 1 + dim_feature * dim_feature + N_samples + 1;
conic_var_list = (root_sum_sq_var_id + 1): total_var;
cones{1}.sub = [root_sum_sq_var_id, conic_var_list];
%%%% Initial Solution
x_init(root_sum_sq_var_id) = sqrt(x_init(conic_var_list) * x_init(conic_var_list)');

formulate_form_mosek.a = MatrixA;
formulate_form_mosek.blc = RHS_Low;
formulate_form_mosek.buc = RHS_Upp;
formulate_form_mosek.blx = blx;
formulate_form_mosek.bux = bux;
formulate_form_mosek.c = c;
formulate_form_mosek.cones = cones;
formulate_form_mosek.sol.itr.xx = x_init;

