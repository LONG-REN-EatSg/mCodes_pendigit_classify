function [ptn_info] = ptn_calc_cov_mat(ptn_info, pen_digit_case)
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

%%%%%%%%%%%%%%%%
total_constr = ptn_info.N + ptn_info.dim_feature * ptn_info.dim_feature;
total_var = 1 + ptn_info.dim_feature * ptn_info.dim_feature + ptn_info.N + 1 + ptn_info.dim_feature + ...
    (ptn_info.dim_feature + 1)*ptn_info.dim_feature /2;

TemplateMatrixA = sparse(total_constr, total_var);
error_var_start_index = ptn_info.dim_feature * ptn_info.dim_feature + 1;
var_1st_ord_start = ptn_info.dim_feature * ptn_info.dim_feature + ptn_info.N + 2;
for ii = 1:1:ptn_info.N
    scaled_feature(ii).vector = pen_digit_case(ii).feature/ptn_info.scale_feature_factor;
    TemplateMatrixA(ii, 1) = 1;
    psd_variable_list = 1 + 1;
    for jj = 1:1:ptn_info.dim_feature
        for kk = 1:1:ptn_info.dim_feature
            if kk >= jj
                scaled_feature(ii).cov_mat(kk, jj) = scaled_feature(ii).vector(kk) * scaled_feature(ii).vector(jj);
            else
                scaled_feature(ii).cov_mat(kk, jj) = scaled_feature(ii).cov_mat(jj, kk);
            end
            TemplateMatrixA(ii, psd_variable_list) = scaled_feature(ii).cov_mat(kk, jj);
            psd_variable_list = psd_variable_list + 1;
        end
        TemplateMatrixA(ii, var_1st_ord_start + jj) = scaled_feature(ii).vector(jj);
    end
    RHS_Low(ii, 1) = 1;
    RHS_Upp(ii, 1) = inf;
end

matrix_entry_index = 2;
half_symmetric_matrix_var_index = 1 + ptn_info.dim_feature * ptn_info.dim_feature + ptn_info.N + 1 + ptn_info.dim_feature + 1;
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
            TemplateMatrixA(constrain_index, matrix_entry(ii, jj)) = 1;
            TemplateMatrixA(constrain_index, half_sym_mtrix_entry(ii, jj)) = -1;
        else
            TemplateMatrixA(constrain_index, matrix_entry(ii, jj)) = 1;
            TemplateMatrixA(constrain_index, matrix_entry(jj, ii)) = -1;
        end
        RHS_Upp(constrain_index, 1) = 0;
        RHS_Low(constrain_index, 1) = 0;
        constrain_index = constrain_index + 1;
    end
end
RHS_Upp = sparse(RHS_Upp);
RHS_Low = sparse(RHS_Low);

%%% The cost vector
c = sparse([zeros(1 + ptn_info.dim_feature * ptn_info.dim_feature, 1); ptn_info.penalty * ones(ptn_info.N, 1); ...
    1; zeros(ptn_info.dim_feature + ptn_info.dim_feature * (ptn_info.dim_feature + 1)/2, 1)]);
%%% Range of variables
blx = sparse([ -inf * ones(1 + ptn_info.dim_feature * ptn_info.dim_feature, 1); ...
               zeros(ptn_info.N + 1, 1); ...
               -inf * ones(ptn_info.dim_feature + ptn_info.dim_feature * (ptn_info.dim_feature + 1)/2, 1)]);

bux = sparse([ inf * ones(total_var, 1)]);
%%% conic constraints
cones = cell(1,1);
cones{1}.type = 'MSK_CT_QUAD';
root_sum_sq_var_id = 1 + ptn_info.dim_feature * ptn_info.dim_feature + ptn_info.N + 1;
conic_var_list = (root_sum_sq_var_id + 1): total_var;
cones{1}.sub = [root_sum_sq_var_id, conic_var_list];


ptn_info.scaled_feature = scaled_feature;
ptn_info.mosek_form.TemplateMatrixA = TemplateMatrixA;
ptn_info.mosek_form.RHS_Upp = RHS_Upp;
ptn_info.mosek_form.RHS_Low = RHS_Low;
ptn_info.mosek_form.c = c;
ptn_info.mosek_form.blx = blx;
ptn_info.mosek_form.bux = bux;
ptn_info.mosek_form.cones = cones;