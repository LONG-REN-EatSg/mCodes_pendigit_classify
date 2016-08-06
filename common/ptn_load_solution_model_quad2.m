% routine, ptn_load_solution_model_quad2

close all
clear all

[pen_digit_case, num_total_cases] = load_data;
%[pen_digit_case, num_total_cases] = ptn_load_test_data;
dim_feature = length(pen_digit_case(1).feature);

[ptn_info] = ptn_load_config();
ptn_info.dim_feature = dim_feature;
if  ptn_info.N > num_total_cases
    ptn_info.N = num_total_cases - 1;
end
N = ptn_info.N;
if ~isfield(ptn_info, 'total_class')
    ptn_info.total_class = 10;
end

disp('load solution');
uiload

t1 = cputime;
[pattern_identify, remain_error] = ptn_verify_model_05(class_model, pen_digit_case, ptn_info);
identify_time = cputime - t1

%ptn_plot_master(pen_digit_case, pattern_identify, ptn_info);

figure(30);
if ptn_info.model_option == 4
    for ii = 1:1:10
        subplot(2,5, ii);
        ptn_plot_likelehood_quad2(pen_digit_case, class_model(ii), ptn_info);
        strTitle = sprintf('L_%d(feature): for class %d', ii - 1, ii - 1);
        title(strTitle);
    end
end

figure(40);
rand_sample = floor(num_total_cases * rand(1, 1));
if rand_sample <= 0
    rand_sample = 1;
end
ptn_plot_1_likelihood_quad2(pen_digit_case,  rand_sample, ptn_info, class_model);
