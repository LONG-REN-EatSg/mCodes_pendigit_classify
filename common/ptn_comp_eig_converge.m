close all
clear all;

N_list = [800, 1000, 2000, 5000, 6000];
uiload

[pen_digit_case, num_total_cases] = load_data;
dim_feature = length(pen_digit_case(1).feature);

[ptn_info] = ptn_load_config();
ptn_info.dim_feature = dim_feature;


class_model = model_800;
ptn_info.N = 800;
[pattern_identify, remain_error] = ptn_verify_model_05(class_model, pen_digit_case, ptn_info);
error_samples_training = find(remain_error(1:ptn_info.N));
error_samples_testing = find(remain_error(ptn_info.N:num_total_cases));
total_error_training(1) = size(error_samples_training, 2)/ptn_info.N;
total_error_testing(1) = size(error_samples_testing, 2)/(num_total_cases - ptn_info.N);

class_model = model_1000;
ptn_info.N = 1000;
[pattern_identify, remain_error] = ptn_verify_model_05(class_model, pen_digit_case, ptn_info);
error_samples_training = find(remain_error(1:ptn_info.N));
error_samples_testing = find(remain_error(ptn_info.N:num_total_cases));
total_error_training(2) = size(error_samples_training, 2)/ptn_info.N;
total_error_testing(2) = size(error_samples_testing, 2)/(num_total_cases - ptn_info.N);

class_model = model_2000;
ptn_info.N = 2000;
[pattern_identify, remain_error] = ptn_verify_model_05(class_model, pen_digit_case, ptn_info);
error_samples_training = find(remain_error(1:ptn_info.N));
error_samples_testing = find(remain_error(ptn_info.N:num_total_cases));
total_error_training(3) = size(error_samples_training, 2)/ptn_info.N;
total_error_testing(3) = size(error_samples_testing, 2)/(num_total_cases - ptn_info.N);

class_model = model_5000;
ptn_info.N = 5000;
[pattern_identify, remain_error] = ptn_verify_model_05(class_model, pen_digit_case, ptn_info);
error_samples_training = find(remain_error(1:ptn_info.N));
error_samples_testing = find(remain_error(ptn_info.N:num_total_cases));
total_error_training(4) = size(error_samples_training, 2)/ptn_info.N;
total_error_testing(4) = size(error_samples_testing, 2)/(num_total_cases - ptn_info.N);

class_model = model_6000;
ptn_info.N = 6000;
[pattern_identify, remain_error] = ptn_verify_model_05(class_model, pen_digit_case, ptn_info);
error_samples_training = find(remain_error(1:ptn_info.N));
error_samples_testing = find(remain_error(ptn_info.N:num_total_cases));
total_error_training(5) = size(error_samples_training, 2)/ptn_info.N;
total_error_testing(5) = size(error_samples_testing, 2)/(num_total_cases - ptn_info.N);

figure(30)
plot(N_list, total_error_training, N_list, total_error_testing);
title('Classification Error v.s. No. of Training Samples')
xlabel('total training samples')
ylabel('percentage of error');
legend('taining set error', 'testing set error');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 1:1:10
    eig_comp(1).eig_list(ii, :) = eig(model_800(ii).Model_Ord2.ModelMatrix);
    eig_comp(1).teaching_samples = 800;
end

for ii = 1:1:10
    eig_comp(2).eig_list(ii, :) = eig(model_1000(ii).Model_Ord2.ModelMatrix);
    eig_comp(2).teaching_samples = 1000;
end

for ii = 1:1:10
    eig_comp(3).eig_list(ii, :) = eig(model_2000(ii).Model_Ord2.ModelMatrix);
    eig_comp(3).teaching_samples = 2000;
end

for ii = 1:1:10
    eig_comp(4).eig_list(ii, :) = eig(model_5000(ii).Model_Ord2.ModelMatrix);
    eig_comp(4).teaching_samples = 5000;
end

for ii = 1:1:10
    eig_comp(5).eig_list(ii, :) = eig(model_6000(ii).Model_Ord2.ModelMatrix);
    eig_comp(5).teaching_samples = 6000;
end

figure(1);
for ii = 1:1:10
    subplot(2,5,ii);
    hold on;
    grid on;
    for jj = 1:1:5
        eig_list_size = max(size(eig_comp(jj).eig_list(ii,:)));
        x = eig_comp(jj).teaching_samples * ones(eig_list_size, 1);
        plot(x, eig_comp(jj).eig_list(ii,:), '*');
        
    end
    strText = sprintf('Matrix in L_%d(feature)', ii - 1);
    title(strText);
    ylabel('Eigenvalue List')
    xlabel('Training Samples');
end