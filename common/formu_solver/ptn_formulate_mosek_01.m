function [formulate_form_mosek] = ptn_formulate_mosek_01(ptn_info, pen_digit_case)
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

total_constr = ptn_info.N + ptn_info.dim_feature * ptn_info.dim_feature;
total_var = 1 + ptn_info.dim_feature * ptn_info.dim_feature + ptn_info.N + 1 + ptn_info.dim_feature + ...
    (ptn_info.dim_feature + 1)*ptn_info.dim_feature /2;

MatrixA = ptn_info.mosek_form.TemplateMatrixA;
%%% Formulate the constraints
%%% 1st kind of constraints: error from each model output to each sample
error_var_start_index = ptn_info.dim_feature * ptn_info.dim_feature + 1;
for ii = 1:1:ptn_info.N
    if ptn_info.model_class_id ~= pen_digit_case(ii).class
        MatrixA(ii, :) = -1 * MatrixA(ii, :);
    end
    MatrixA(ii, ii+ error_var_start_index) = 1;   % variable indicating the error distance between the model output and the class_id
end

formulate_form_mosek.a = MatrixA;
formulate_form_mosek.blc = ptn_info.mosek_form.RHS_Low;
formulate_form_mosek.buc = ptn_info.mosek_form.RHS_Upp;
formulate_form_mosek.blx = ptn_info.mosek_form.blx;
formulate_form_mosek.bux = ptn_info.mosek_form.bux;
formulate_form_mosek.c = ptn_info.mosek_form.c;
formulate_form_mosek.cones = ptn_info.mosek_form.cones;

