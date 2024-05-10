

close all

flag_load_data = input('Whether to reset memory and load data: [0: No, Else: Yes]: ');

if flag_load_data ~= 0
    clear all
    [pen_digit_case, num_total_cases] = load_data;
    [pen_digit_test, num_total_test] = ptn_load_test_data;
end

%% Dimension of features
dim_feature = length(pen_digit_case(1).feature);
ptn_info.total_class = 10;
training_samples = [1000, 3000, 5000, 7000];

strDisp = sprintf('Total number of samples: %d', num_total_cases);
disp(strDisp);

total_sample_test = length(pen_digit_test);
for nn= 1:1:1
    for ll = 1:1:5
        ptn_info.len_Knn = ll;
        ptn_info.N = training_samples(nn);
        [pattern_identify, remain_error, total_num_fail] = ptn_verify_knn_test(pen_digit_case, ptn_info, pen_digit_test);
        knn_fail_rate(ll, nn) = total_num_fail/total_sample_test
    end
end