function [pattern_identify, remain_error] = ptn_verify_linear_kessler(model_linear, pen_digit_case, ptn_info)
%
%
%
%


total_sample = max(size(pen_digit_case));
for ii = 1:1:total_sample
    max_likelihood = -inf;
    pattern_identify(ii) = -1;
    for jj = 1:1:ptn_info.total_class
        likelihood_jj = pen_digit_case(ii).feature * model_linear(jj).factor + model_linear(jj).offset;
        if likelihood_jj > max_likelihood
            max_likelihood = likelihood_jj;
            pattern_identify(ii) = model_linear(jj).class_id;
        end
    end
    remain_error(ii) = pattern_identify(ii) - pen_digit_case(ii).class;
end

%stop_on_error = 0;
%ptn_plot_error_case_4by4(pattern_identify, pen_digit_case, ptn_info, stop_on_error);

