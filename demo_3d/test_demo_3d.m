strTestOutPath = 'D:\WD-Zhengyi\PatternClassify';    

[astSampleCase, num_total_cases] = load_demo_3d([strTestOutPath, '\data_ellipsoid.mat'], 1);
%% Dimension of features
dim_feature = length(astSampleCase(1).feature);
%num_total_cases = length(astSampleCase);
strDisp = sprintf('Total number of samples: %d', num_total_cases);
disp(strDisp);

%%% Quadratic Classifier with Sedumi solver
    strFilenamConfig = strcat(strTestOutPath, '\quad2\pattern_config.ini');
    [ptn_info] = ptn_load_config(strFilenamConfig);
    rel_pattern(strFilenamConfig, astSampleCase, num_total_cases);

    %%% Quadratic Classifier with MOSEK solver
%    rel_pen(strcat(strTestOutPath, 'quad2_msk\quad2_400\ptn_config.ini'))
    
    %%% Gaussian PDF (Probability Distribution Function) classifer for 1000 learning samples
    %rel_pen(strcat(strTestOutPath, 'gauss_pdf\1000\ptn_config.ini'))
    input('Now is Gaussian PDF classifer for 1000 learning samples, any key');

    %% K-NN (K Nearest Neighbourhood)classifier for 1000 learning samples
    %rel_pen(strcat(strTestOutPath, 'k_nn\1000\ptn_config.ini'))
    input('Now is K-NN classifier for 1000 learning samples, any key');

    %% Linear Kessler Classifier
    %rel_pen(strcat(strTestOutPath, 'linear\kessler_1000\ptn_config.ini'))
    input('Now is Linear Kessler Classifier, any key');
