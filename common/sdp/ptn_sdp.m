close all

flag_load_data = input('Whether to reset memory and load data: [0: No, Else: Yes]: ');

if flag_load_data ~= 0
    clear all
    [pen_digit_case, num_total_cases] = load_data;
end

%% Dimension of features
dim_feature = length(pen_digit_case(1).feature);

strDisp = sprintf('Total number of samples: %d', num_total_cases);
disp(strDisp);
%N = input('Input actual number of cases for teaching: ');
%model_option = input('Input Model Option -- [0: PSD Only, 1: PSD + 1st order + offset, 2: PSD + 1st order, 3: No PSD + 1st + ofst, 4: each class has one 2nd order model]: ');

%Template for model option
%if model_option == 0
%elseif model_option == 1
%else
%    error('Error Model Option');
%end
[ptn_info] = ptn_load_config;
ptn_info.dim_feature = dim_feature;
N = ptn_info.N

if bitand(ptn_info.model_option, 16) ~= 0
    %%% enaable PCA
    ptn_info.pca_level = 0.95;
    [ptn_pca_output] = ptn_pca_find_largest_eigs(pen_digit_case, ptn_info);
    pen_digit_case_pca = ptn_pca_output.pen_digit_case_pca;
    ptn_info.dim_feature = length(ptn_pca_output.pca_dim_list);
end
if ~isfield(ptn_info, 'total_class')
    ptn_info.total_class = 10;
end

if ptn_info.model_option == 0
    [formulate_form_sedumi] = ptn_formulate_sedumi(ptn_info, pen_digit_case);
elseif ptn_info.model_option == 1
    [formulate_form_sedumi] = ptn_formulate_sedumi_02(ptn_info, pen_digit_case);
elseif ptn_info.model_option == 2
    [formulate_form_sedumi] = ptn_formulate_sedumi_03(ptn_info, pen_digit_case);
elseif ptn_info.model_option == 3
    [formulate_form_sedumi] = ptn_formulate_sedumi_04(ptn_info, pen_digit_case);
elseif ptn_info.model_option == 4
    cpu_time_learning = 0;
    for ii = 0:1:9
        ptn_info.model_class_id = ii
        [class_model_ii, solver_info] = ptn_sedumi_solve_id_05(ptn_info, pen_digit_case);
        class_model(ii+1) = class_model_ii;
        cpu_time_learning = cpu_time_learning + solver_info.solution_info.cpusec;
        info = solver_info.solution_info;
        solution_x(:, ii+1) =  solver_info.x;
    end
elseif ptn_info.model_option == 20
    cpu_time_learning = 0;
    for ii = 0:1:9
        ptn_info.model_class_id = ii
        [class_model_ii, solver_info] = ptn_sedumi_solve_id_05(ptn_info, pen_digit_case_pca);
        class_model(ii+1) = class_model_ii;
        cpu_time_learning = cpu_time_learning + solver_info.solution_info.cpusec;
        info = solver_info.solution_info;
        solution_x(:, ii+1) =  solver_info.x;
    end
elseif ptn_info.model_option == 5  %% Linear Kessler Construction
    cpu_time_learning = cputime;
    [ptn_kessler_formulation] = ptn_linear_kessler_formulate(ptn_info, pen_digit_case);
    [ptn_kessler_solution] = ptn_linear_kessler_solver(ptn_kessler_formulation);
    cpu_time_learning = cputime - cpu_time_learning
elseif ptn_info.model_option == 21  %% Linear Kessler Construction
    cpu_time_learning = cputime;
    [ptn_kessler_formulation_pca] = ptn_linear_kessler_formulate(ptn_info, pen_digit_case_pca);
    [ptn_kessler_solution_pca] = ptn_linear_kessler_solver(ptn_kessler_formulation_pca);
    cpu_time_learning = cputime - cpu_time_learning

elseif ptn_info.model_option == 6  %% K-NN
elseif ptn_info.model_option == 7  %% unsupervised learning, clustering
    [ptn_cluster_solution] = ptn_cluster_basic_k_means(ptn_info, pen_digit_case);
    
elseif ptn_info.model_option == 22
elseif ptn_info.model_option == 8
    cpu_time_learning = cputime;
    [class_model] = ptn_solve_gaussian_pdf(pen_digit_case, ptn_info);
    cpu_time_learning = cputime - cpu_time_learning
elseif ptn_info.model_option == 24
    cpu_time_learning = cputime;
    [class_model] = ptn_solve_gaussian_pdf(pen_digit_case_pca, ptn_info);
    cpu_time_learning = cputime - cpu_time_learning
else
    error('Error Model Option');
end


%%% solving the problem by sedumi
if ptn_info.model_option == 0 | ptn_info.model_option == 1 | ptn_info.model_option == 2 | ptn_info.model_option == 3
    pars.maxiter = 30;
    pars.bigeps = 0.01;
    [x, y, info] = sedumi(formulate_form_sedumi.A, formulate_form_sedumi.b, formulate_form_sedumi.c, formulate_form_sedumi.K, pars);
    cpu_time = info.cpusec;
    if(info.pinf ==1 | info.dinf == 1)
        error('Infeasible Solution Happens')
    end
end

if ptn_info.model_option == 5  %% Linear Kessler Construction
end

%%%%
if ptn_info.model_option == 0
    [ModelMatrix] = ptn_construct_model(N, dim_feature, x);
    Model_Ord2.ModelLinearVec = zeros(dim_feature, 1);
    Model_Ord2.ModelOffset = 0;
    Model_Ord2.ModelMatrix = ModelMatrix;
elseif ptn_info.model_option == 1
    [Model_Ord2] = ptn_construct_model_02(N, dim_feature, x);
    %[ModelMatrix, ModelLinearVec, ModelOffset] = ptn_construct_model_02(N, dim_feature, x);
elseif ptn_info.model_option == 2
    [Model_Ord2] = ptn_construct_model_03(N, dim_feature, x);
elseif ptn_info.model_option == 3
    [Model_Ord2] = ptn_construct_model_04(N, dim_feature, x);
elseif ptn_info.model_option == 4
elseif ptn_info.model_option == 20
elseif ptn_info.model_option == 5  %% Linear Kessler Construction
    [model_linear] = ptn_construct_kesseler_model(ptn_kessler_solution);
elseif ptn_info.model_option == 21  %% Linear Kessler Construction
    [model_linear] = ptn_construct_kesseler_model(ptn_kessler_solution_pca);
elseif ptn_info.model_option == 6
elseif ptn_info.model_option == 22
elseif ptn_info.model_option == 7
elseif ptn_info.model_option == 8
elseif ptn_info.model_option == 24
else
    error('Error Model Option');
end

%%% verify the remaining cases
if ptn_info.model_option == 0 | ptn_info.model_option == 1 | ptn_info.model_option == 2 | ptn_info.model_option == 3
    for jj = 1 : 1: num_total_cases
%    omega_squre = pen_digit_case(jj).feature' * pen_digit_case(jj).feature; %%% pen_digit_case(jj).feature is row vector
%    pattern_identify(jj ) = 0;
%    for kk = 1:1:dim_feature
%        for ii = 1:1:dim_feature
%            pattern_identify(jj ) = pattern_identify(jj) + Model_Ord2.ModelMatrix(kk, ii) * omega_squre(kk, ii);
%        end
%    end
%    pattern_identify(jj) = pattern_identify(jj) + pen_digit_case(jj).feature * Model_Ord2.ModelLinearVec + Model_Ord2.ModelOffset;
        pattern_identify(jj) = pen_digit_case(jj).feature * Model_Ord2.ModelMatrix * pen_digit_case(jj).feature'/ptn_info.scale_feature_factor/ptn_info.scale_feature_factor + ...
            pen_digit_case(jj).feature *Model_Ord2.ModelLinearVec/ptn_info.scale_feature_factor + Model_Ord2.ModelOffset;
        pattern_identify(jj) = (pattern_identify(jj) - ptn_info.scale_offset)/ptn_info.scale_factor;
        remain_error(jj) =  pattern_identify(jj) - pen_digit_case(jj).class;
    end
elseif ptn_info.model_option == 4
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_model_05(class_model, pen_digit_case, ptn_info);
    identify_time = cputime - t1
elseif ptn_info.model_option == 20
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_model_05(class_model, pen_digit_case_pca, ptn_info);
    identify_time = cputime - t1
elseif ptn_info.model_option == 5  %% Linear Kessler Construction
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_linear_kessler(model_linear, pen_digit_case, ptn_info);
    identify_time = cputime - t1
elseif ptn_info.model_option == 21  %% Linear Kessler Construction
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_linear_kessler(model_linear, pen_digit_case_pca, ptn_info);
    identify_time = cputime - t1
    
elseif ptn_info.model_option == 6
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_knn(pen_digit_case, ptn_info);
    identify_time = cputime - t1
   
elseif ptn_info.model_option == 22
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_knn(pen_digit_case_pca, ptn_info);
    identify_time = cputime - t1
elseif ptn_info.model_option == 7
elseif ptn_info.model_option == 8
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_gaussian_pdf(pen_digit_case, ptn_info, class_model);
    identify_time = cputime - t1
elseif ptn_info.model_option == 24
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_gaussian_pdf(pen_digit_case_pca, ptn_info, class_model);
    identify_time = cputime - t1
    
else
    
end

%%% verify the Given cases:
if ptn_info.model_option == 0 | ptn_info.model_option == 1 | ptn_info.model_option == 2 | ptn_info.model_option == 3
    figure(2);
    if ptn_info.model_option == 0
        ptn_plot_modeling_error(x, N, remain_error);
    elseif ptn_info.model_option == 1
        ptn_plot_modeling_error_02(x, dim_feature, N, remain_error);
    elseif ptn_info.model_option == 2
        ptn_plot_modeling_error_03(x, dim_feature, N, remain_error);
    elseif ptn_info.model_option == 3
        ptn_plot_modeling_error_04(x, dim_feature, N, remain_error);
    else
        error('Error Model Option');
    end
end
%%% by mean and variance
if bitand(ptn_info.model_option, 16) ~= 0
    ptn_plot_master(pen_digit_case_pca, pattern_identify, ptn_info);
else
    ptn_plot_master(pen_digit_case, pattern_identify, ptn_info);
end


if ptn_info.model_option == 4
    figure(30);
    for ii = 1:1:ptn_info.total_class
        subplot(2,5, ii);
        ptn_plot_likelehood_quad2(pen_digit_case, class_model(ii), ptn_info);
        strTitle = sprintf('L_%d(feature): for class %d', ii - 1, ii - 1);
        title(strTitle);
    end
elseif ptn_info.model_option == 20
    figure(30);
    for ii = 1:1:ptn_info.total_class
        subplot(2,5, ii);
        ptn_plot_likelehood_quad2(pen_digit_case_pca, class_model(ii), ptn_info);
        strTitle = sprintf('L_%d(feature): for class %d', ii - 1, ii - 1);
        title(strTitle);
    end
elseif ptn_info.model_option == 5
    figure(30);
    for ii = 1:1:ptn_info.total_class
        subplot(2,5, ii);
        ptn_plot_likelehood_linear(pen_digit_case, model_linear(ii), ptn_info);
        strTitle = sprintf('L_%d(feature): for class %d', ii - 1, ii - 1);
        title(strTitle);
    end
elseif ptn_info.model_option == 21
    figure(30);
    for ii = 1:1:ptn_info.total_class
        subplot(2,5, ii);
        ptn_plot_likelehood_linear(pen_digit_case_pca, model_linear(ii), ptn_info);
        strTitle = sprintf('L_%d(feature): for class %d', ii - 1, ii - 1);
        title(strTitle);
    end
elseif ptn_info.model_option == 8
    figure(30);
    for ii = 1:1:ptn_info.total_class
        subplot(2,5, ii);
        ptn_plot_likelehood_gauss_pdf(pen_digit_case, class_model(ii), ptn_info);
        strTitle = sprintf('Value: L_%d(feature): for class %d', ii - 1, ii - 1);
        ylabel(strTitle);
    end
elseif ptn_info.model_option == 24
    figure(30);
    for ii = 1:1:ptn_info.total_class
        subplot(2,5, ii);
        ptn_plot_likelehood_gauss_pdf(pen_digit_case_pca, class_model(ii), ptn_info);
        strTitle = sprintf('Value: L_%d(feature): for class %d', ii - 1, ii - 1);
        ylabel(strTitle);
    end
else
end

if ptn_info.model_option == 0 | ptn_info.model_option == 1 | ptn_info.model_option == 2 | ptn_info.model_option == 3 | ptn_info.model_option == 4
    if info.numerr == 1
        disp('Solver terminating without ahcieving the desired accuracy.')
    elseif info.numerr == 2
        error('solver completely fail');
    else
    end
end

