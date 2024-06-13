close all

clear astSampleCase ptn_info class_model solution_x
flag_load_data = input('[1: pen-digits classify, 2: a simple 2-d classify demo] ');
%
%
% History
% YYYYMMDD  Notes
% 20071111  replace nameing for structure array "pen_digit_case" to
% astSampleCase: array of structure, while keep the content and field
% struct: {'x', 'y', 'class', 'feature'}

if flag_load_data ~= 0
    [ptn_info, astSampleCase] = ptn_load_data_and_cfg(flag_load_data)
end

dim_feature = length(astSampleCase(1).feature);
N = ptn_info.N;

%%%%%%%%%%%%%%%% PCA: Principal Component Analysis
if bitand(ptn_info.model_option, 16) ~= 0
    %%% enaable PCA
    ptn_info.pca_level = 0.95;
    [ptn_pca_output] = ptn_pca_find_largest_eigs(astSampleCase, ptn_info);
    astSampleCase_pca = ptn_pca_output.astSampleCase_pca;
    ptn_info.dim_feature = length(ptn_pca_output.pca_dim_list);
end
if ~isfield(ptn_info, 'total_class')
    ptn_info.total_class = 10;
end

model_linear = [];

%%%%%%%%%%%%%%%%%
if ptn_info.model_option == 0
    [formulate_form_sedumi] = ptn_formulate_sedumi(ptn_info, astSampleCase);
elseif ptn_info.model_option == 1
    [formulate_form_sedumi] = ptn_formulate_sedumi_02(ptn_info, astSampleCase);
elseif ptn_info.model_option == 2
    [formulate_form_sedumi] = ptn_formulate_sedumi_03(ptn_info, astSampleCase);
elseif ptn_info.model_option == 3
    [formulate_form_sedumi] = ptn_formulate_sedumi_04(ptn_info, astSampleCase);
elseif ptn_info.model_option == 4              %%%%%%%% Quadratic Model
    cpu_time_learning = 0;
    for ii = 0:1:(ptn_info.total_class - 1)  %% 0:1:9
        ptn_info.model_class_id = ii
        [class_model_ii, solver_info] = ptn_sedumi_solve_id_05(ptn_info, astSampleCase);
        class_model(ii+1) = class_model_ii;
        cpu_time_learning = cpu_time_learning + solver_info.solution_info.cpusec;
        info = solver_info.solution_info;
        solution_x(:, ii+1) =  solver_info.x;
    end
elseif ptn_info.model_option == 20             %%%%%%%% Quadratic Model with PCA input
    cpu_time_learning = 0;
    for ii = 0:1:(ptn_info.total_class - 1)
        ptn_info.model_class_id = ii
        [class_model_ii, solver_info] = ptn_sedumi_solve_id_05(ptn_info, astSampleCase_pca);
        class_model(ii+1) = class_model_ii;
        cpu_time_learning = cpu_time_learning + solver_info.solution_info.cpusec;
        info = solver_info.solution_info;
        solution_x(:, ii+1) =  solver_info.x;
    end
elseif ptn_info.model_option == 5  %% Linear Kessler Construction
    cpu_time_learning = cputime;
    [ptn_kessler_formulation] = ptn_linear_kessler_formulate(ptn_info, astSampleCase);
    [ptn_kessler_solution] = ptn_linear_kessler_solver(ptn_kessler_formulation);
    cpu_time_learning = cputime - cpu_time_learning
elseif ptn_info.model_option == 21  %% Linear Kessler Construction with PCA
    cpu_time_learning = cputime;
    [ptn_kessler_formulation_pca] = ptn_linear_kessler_formulate(ptn_info, astSampleCase_pca);
    [ptn_kessler_solution_pca] = ptn_linear_kessler_solver(ptn_kessler_formulation_pca);
    cpu_time_learning = cputime - cpu_time_learning

elseif ptn_info.model_option == 6  %% K-NN
    %%% no learning process in K-NN
elseif ptn_info.model_option == 7  %% unsupervised learning, clustering
    [ptn_cluster_solution] = ptn_cluster_basic_k_means(ptn_info, astSampleCase);
    
elseif ptn_info.model_option == 22
    %%% no learning process in K-NN with PCA
elseif ptn_info.model_option == 8   %% Gaussian PDF(Probability Density Function), learning process
    cpu_time_learning = cputime;
    [class_model] = ptn_solve_gaussian_pdf(astSampleCase, ptn_info);
    cpu_time_learning = cputime - cpu_time_learning
elseif ptn_info.model_option == 24   %% Gaussian PDF with PCA
    cpu_time_learning = cputime;
    [class_model] = ptn_solve_gaussian_pdf(astSampleCase_pca, ptn_info);
    cpu_time_learning = cputime - cpu_time_learning
elseif ptn_info.model_option == 9              %%%%%%%% Quadratic Model, Solved by MOSEK
    cpu_time_learning = 0;
    [ptn_info] = ptn_calc_cov_mat(ptn_info, astSampleCase);
    for ii = 0:1:(ptn_info.total_class - 1)
        model_class_id = ii
        ptn_info.model_class_id = ii;
        [class_model_ii, solver_info] = ptn_mosek_solve_id(ptn_info, astSampleCase);
        class_model(ii+1) = class_model_ii;
        cpu_time_learning = cpu_time_learning + solver_info.cpusec;
%        size(solver_info.x)
%        solution_x(:, ii+1) =  solver_info.x;
    end
elseif ptn_info.model_option == 25             %%%%%%%% Quadratic Model with PCA input, Solved by MOSEK
    cpu_time_learning = 0;
    [ptn_info] = ptn_calc_cov_mat(ptn_info, astSampleCase);
    for ii = 0:1:(ptn_info.total_class - 1)
        ptn_info.model_class_id = ii
        [class_model_ii, solver_info] = ptn_mosek_solve_id(ptn_info, astSampleCase_pca);
        class_model(ii+1) = class_model_ii;
        cpu_time_learning = cpu_time_learning + solver_info.cpusec;
%        solution_x(:, ii+1) =  solver_info.x;
    end
elseif ptn_info.model_option == 10              %%%%%%%% Quadratic Model, Solved by MOSEK, preprocess to get x_init
    cpu_time_learning = 0;
    [ptn_info] = ptn_calc_cov_mat(ptn_info, astSampleCase);
    for ii = 0:1:(ptn_info.total_class - 1)
        model_class_id = ii
        ptn_info.model_class_id = ii;
        [class_model_ii, solver_info] = ptn_mosek_solve_id_02(ptn_info, astSampleCase);
        class_model(ii+1) = class_model_ii;
        cpu_time_learning = cpu_time_learning + solver_info.cpusec;
%        size(solver_info.x)
%        solution_x(:, ii+1) =  solver_info.x;
    end
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

%%%%  Construction the model
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
elseif ptn_info.model_option == 9
elseif ptn_info.model_option == 25
elseif ptn_info.model_option == 10
elseif ptn_info.model_option == 26
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
%    omega_squre = astSampleCase(jj).feature' * astSampleCase(jj).feature; %%% astSampleCase(jj).feature is row vector
%    pattern_identify(jj ) = 0;
%    for kk = 1:1:dim_feature
%        for ii = 1:1:dim_feature
%            pattern_identify(jj ) = pattern_identify(jj) + Model_Ord2.ModelMatrix(kk, ii) * omega_squre(kk, ii);
%        end
%    end
%    pattern_identify(jj) = pattern_identify(jj) + astSampleCase(jj).feature * Model_Ord2.ModelLinearVec + Model_Ord2.ModelOffset;
        pattern_identify(jj) = astSampleCase(jj).feature * Model_Ord2.ModelMatrix * astSampleCase(jj).feature'/ptn_info.scale_feature_factor/ptn_info.scale_feature_factor + ...
            astSampleCase(jj).feature *Model_Ord2.ModelLinearVec/ptn_info.scale_feature_factor + Model_Ord2.ModelOffset;
        pattern_identify(jj) = (pattern_identify(jj) - ptn_info.scale_offset)/ptn_info.scale_factor;
        remain_error(jj) =  pattern_identify(jj) - astSampleCase(jj).class;
    end
elseif ptn_info.model_option == 4 | ptn_info.model_option == 9 | ptn_info.model_option == 10
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_model_05(class_model, astSampleCase, ptn_info);
    identify_time = cputime - t1
elseif ptn_info.model_option == 20 | ptn_info.model_option == 25 | ptn_info.model_option == 26
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_model_05(class_model, astSampleCase_pca, ptn_info);
    identify_time = cputime - t1
elseif ptn_info.model_option == 5  %% Linear Kessler Construction
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_linear_kessler(model_linear, astSampleCase, ptn_info);
    identify_time = cputime - t1
elseif ptn_info.model_option == 21  %% Linear Kessler Construction
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_linear_kessler(model_linear, astSampleCase_pca, ptn_info);
    identify_time = cputime - t1
    
elseif ptn_info.model_option == 6
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_knn(astSampleCase, ptn_info);
    identify_time = cputime - t1
   
elseif ptn_info.model_option == 22
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_knn(astSampleCase_pca, ptn_info);
    identify_time = cputime - t1
elseif ptn_info.model_option == 7
elseif ptn_info.model_option == 8
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_gaussian_pdf(astSampleCase, ptn_info, class_model);
    identify_time = cputime - t1
elseif ptn_info.model_option == 24
    t1 = cputime;
    [pattern_identify, remain_error] = ptn_verify_gaussian_pdf(astSampleCase_pca, ptn_info, class_model);
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
    ptn_plot_master(astSampleCase_pca, pattern_identify, ptn_info);
    ptn_plot_master_2(astSampleCase_pca, pattern_identify, ptn_info);
else
    ptn_plot_master(astSampleCase, pattern_identify, ptn_info);
    ptn_plot_master_2(astSampleCase, pattern_identify, ptn_info);
end

iFigId = 30;
ptn_plot_likelihood(astSampleCase, class_model, model_linear, ptn_info, iFigId);

if flag_load_data == 2
    x = linspace(-1, 1, 100);
    y = linspace(-1, 1, 100);
    z1 = gen_quad_fun_val(class_model(1).Model_Ord2, x, y);
    z2 = gen_quad_fun_val(class_model(2).Model_Ord2, x, y);
    x_cv = [];
    y_cv = [];
    eps = 1e-2;
    iNumData = 0;
    for ii = 1:1:100
        for jj = 1:1:100
            if abs(z1(jj, ii)) <= eps
                iNumData = iNumData + 1;
                x_cv(iNumData) = x(ii);
                y_cv(iNumData) = y(jj);
            end
        end
    end
    input('any key to see the classify')
    figure(20)
    plot(x_cv(1:7), y_cv(1:7), 'r-', x_cv(8:end), y_cv(8:end), 'r-');
    
    figure(31);
    mesh(x, y, z1);
    title('likihood function- class 1');
    figure(32);
    mesh(x, y, z2);
    title('likihood function- class 2');
end

if ptn_info.model_option == 0 | ptn_info.model_option == 1 | ptn_info.model_option == 2 | ptn_info.model_option == 3 | ptn_info.model_option == 4
    if info.numerr == 1
        disp('Solver terminating without ahcieving the desired accuracy.')
    elseif info.numerr == 2
        error('solver completely fail');
    else
    end
end

