function ptn_plot_master_2(pen_digit_case, pattern_identify, ptn_info)
%  pen_digit_case:   an array of struct including the trianing data and expected class
%     x: x coordinate
%     y: y coordinate
%     class:  expected class
%     feature: [x1, y1] ... [x8, y8]
%  pattern_identify: Actual identified pattern output by the model.
%  ptn_info: a struct indicating solution configuration
%     scale_feature_factor:
%     scale_factor: 
%     scale_offset: 
%     model_option: 
%     N: total number of samples
%     algo_max_iter: 
%     algo_bigeps: algorithm setting for SEDUMI, BigEps
%     dim_feature: dimension of feature

N = ptn_info.N;
num_total_cases = size(pen_digit_case, 2);

%% only for PositiveSemiDefinite Model
% figure(103)
% ptn_plot_number_accumulate(pen_digit_case, N, pattern_identify);
% 
% figure(104)
% ptn_plot_number_accumulate(pen_digit_case, min(N*5, num_total_cases), pattern_identify);

%%% verify the given cases by mean and variance
pdf_config.low_bound_pdf = -1;
pdf_config.upp_bound_pdf = 10;
pdf_config.length_pdf = round(N/4);
figure(105);
ptn_plot_proba_dens_func(pdf_config,  pattern_identify(1:N));
title('Probability Density of the Learning Samples, Pendigit Identify')

figure(106);
ptn_plot_proba_dens_func(pdf_config,  pattern_identify((N+1): num_total_cases));
title('Probability Density of the Remaining Samples, Pendigit Identify');
