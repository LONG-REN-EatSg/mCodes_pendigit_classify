function [formulate_form_sedumi] = ptn_formulate_sedumi_02(ptn_info, pen_digit_case)
%% [formulate_form_sedumi] = ptn_formulate_sedumi_02(ptn_info, pen_digit_case)
%% Matrix Construction Guidlines
%% First 1 variable: offset
%%      following ptn_info.dim_feature: 1st order coefficience
%%      following 1 variable: sum square error;
%%      following ptn_info.N: error
%%      following ptn_info.dim_feature * ptn_info.dim_feature variables: PSD
%%          matrix
%% Total Number of Contraints:
%%      ptn_info.N + 1

MatrixA = sparse(ptn_info.N, ptn_info.dim_feature * ptn_info.dim_feature);
%%% Formulate the constraints
for ii = 1:1:ptn_info.N
    MatrixA(ii, 1) = 1;
    for jj = 1:1:ptn_info.dim_feature
        MatrixA(ii, 1 + jj) = pen_digit_case(ii).feature(jj)/ptn_info.scale_feature_factor;
    end
    omega_squre = pen_digit_case(ii).feature' * pen_digit_case(ii).feature/ptn_info.scale_feature_factor/ptn_info.scale_feature_factor;
    psd_variable_list = ptn_info.dim_feature + 1 + ptn_info.N + 2;
    for jj = 1:1:ptn_info.dim_feature
        for kk = 1:1:ptn_info.dim_feature
            MatrixA(ii, psd_variable_list) = omega_squre(jj, kk);
            psd_variable_list = psd_variable_list + 1;
        end
    end
    MatrixA(ii, ii+ ptn_info.dim_feature + 2) = 1;   % variable indicating the error distance between the model output and the class_id
    RHS(ii, 1) = pen_digit_case(ii).class * ptn_info.scale_factor + ptn_info.scale_offset;
end

%%% The cost vector
c = sparse([zeros(ptn_info.dim_feature + 1, 1);1; zeros(ptn_info.N + ptn_info.dim_feature * ptn_info.dim_feature, 1)]);

%%% First ptn_info.dim_feature + 1 variables are free
K.f = ptn_info.dim_feature + 1;
%%% following ptn_info.N+1 variables subject to a quadratic cone
K.q = ptn_info.N + 1;
%%% Then ptn_info.dim_feature * ptn_info.dim_feature variables PSD cone
K.s = ptn_info.dim_feature;

formulate_form_sedumi.A = MatrixA;
formulate_form_sedumi.b = RHS;
formulate_form_sedumi.c = c;
formulate_form_sedumi.K = K;
