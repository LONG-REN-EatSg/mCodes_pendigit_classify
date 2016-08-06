function [pattern_identify, remain_error] = ptn_verify_gaussian_pdf(pen_digit_case, ptn_info, class_model)
%
%
%

num_total_samples = length(pen_digit_case);

for ii = 1:1:num_total_samples
    max_likelihood = -inf;
    pattern_identify_list(ii) = -1;
    for cc = 1:1:ptn_info.total_class
        likelihood_cc = ptn_eval_gauss_pdf(class_model(cc), pen_digit_case(ii).feature);
        likelihood_cc = likelihood_cc * class_model(cc).priori;
        if likelihood_cc > max_likelihood
            max_likelihood = likelihood_cc;
            pattern_identify_list(ii) = class_model(cc).class_id;
        end
    end
    remain_error_list(ii) = pattern_identify_list(ii) - pen_digit_case(ii).class;
end

pattern_identify = pattern_identify_list;
remain_error = remain_error_list;
