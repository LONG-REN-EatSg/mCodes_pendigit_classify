function [pattern_identify, remain_error] = ptn_verify_knn(pen_digit_case, ptn_info)

total_samples = max(size(pen_digit_case));

for ii = 1:1:total_samples
    [classify_output] =  ptn_knn_identify(pen_digit_case, ptn_info, pen_digit_case(ii).feature);
    pattern_identify(ii) = classify_output.pattern_identify;
    remain_error(ii) = pattern_identify(ii) - pen_digit_case(ii).class;
    if mod(ii, 100) == 0
        ii
    end
end

