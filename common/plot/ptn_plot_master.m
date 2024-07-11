function [stIdentifyPassFail] = ptn_plot_master(pen_digit_case, pattern_identify, ptn_info)
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

figure(107);
ipf_config.ipf_class_list = (0:1:(ptn_info.total_class - 1));
ipf_config.ipf_total_class = length(ipf_config.ipf_class_list);
[identify_pass_learning, identify_fail_learning] = ptn_plot_identify_pass_fail(ipf_config,  pattern_identify(1:N), pen_digit_case);
title('Pass and Fail Statistis, Pendigit Learning');

figure(108);
ipf_config.ipf_class_list = (0:1:(ptn_info.total_class - 1));
ipf_config.ipf_total_class = length(ipf_config.ipf_class_list);
[identify_pass_verify, identify_fail_verify] = ptn_plot_identify_pass_fail(ipf_config,  pattern_identify((N+1): num_total_cases), pen_digit_case((N+1): num_total_cases));
title('Pass and Fail Statistis, Pendigit Identify');

identify_pass = identify_pass_learning + identify_pass_verify
identify_fail = identify_fail_learning + identify_fail_verify

stIdentifyPassFail.identify_fail = identify_fail;
stIdentifyPassFail.identify_pass  = identify_pass;